class PartiesController < ApplicationController
  before_filter :authenticate

  def index
     @parties = Party.paginate(:page => params[:page])
   end

   def show
     @party = Party.find(params[:id])
   end

   def new
     @party = Party.new
   end

   def create
     #@ = Group.new(params[:group])
     #if @group.save
     #  flash[:success] = "Created new group"
     #  redirect_to new_group_path
     #else
     #  render 'new'
     #end
   end

   def edit
     @party = Party.find(params[:id])
   end

   def update
     @party = Group.find(params[:id])
     if @party.update_attributes(params[:party])
       flash[:success] = "Group updated."
       redirect_to @party
     else
       render 'edit'
     end
   end


   def destroy
     Party.find(params[:id]).destroy
     flash[:success] = "Party destroyed."
     redirect_to parties_path
   end


  private

  def authenticate
    redirect_to(root_path) unless signed_in?
  end

end