class GroupsController < ApplicationController
  before_filter :authenticate



  def index
     @groups = Group.all
   end

   def show
     @group = Group.find(params[:id])
   end

   def new
     @group = Group.new
   end

   def create
     @group = Group.new(params[:group])
     if @group.save
       flash[:success] = "Created new group"
       redirect_to new_group_path
     else
       render 'new'
     end
   end

   def edit
     @group = Group.find(params[:id])
   end

   def update
     @group = Group.find(params[:id])
     if @group.update_attributes(params[:group])
       flash[:success] = "Group updated."
       redirect_to @group
     else
       render 'edit'
     end
   end


   def destroy
     Group.find(params[:id]).destroy
     flash[:success] = "Group destroyed."
     redirect_to groups_path
   end

  def sms
    #investigate using a background process like Delayed Job.

        #BulkMailer.email(@group.parties, "some subject", "some content")
    #@group.parties.each do |party|
    #  logger.info party.email
    #end


    @group = Group.find(params[:id])

    #logger.info params.inspect
    BulkMailer.sms(@group.parties, params[:message])


    flash[:success] = "Emailed group"
    redirect_to show
  end

  def remove_party
    group = Group.find(params[:group_id])
    party = Party.find(params[:party_id])

    group.parties.delete party

    flash[:success] = "Removed from group"
    params.replace(:id => params[:group_id])
    redirect_to show
  end

  private

  def authenticate
    redirect_to(root_path) unless signed_in?
  end

end
