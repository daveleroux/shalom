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


  #def create
  #@ = Group.new(params[:group])
  #if @group.save
  #  flash[:success] = "Created new group"
  #  redirect_to new_group_path
  #else
  #  render 'new'
  #end
  #end

  def edit
    @party = Party.find(params[:id])
  end

  def update
    @party = Party.find(params[:id])
    logger.info "XXXXXXXXXXXXX"
    logger.info params.inspect
    logger.info "XXXXXXXXXXXXX"
    @party.update_attributes(params[:party])
    @party.base_address.update_attributes(params[:base_address])

    @party.party_roles.update params[:role].keys, params[:role].values

    if @party.save
      flash[:success] = "Party updated."
      redirect_to @party.partyize
    else
      flash[:notice] = 'Failed.'
      #render 'edit'
    end
  end


  def destroy
    Party.find(params[:id]).destroy
    flash[:success] = "Party destroyed."
    redirect_to parties_path
  end

  def add_to_group
    @party = Party.find_by_id(params[:party_id])
    if (!@party.nil?)
      @group = Group.find_by_id(params[:groups][:group_id])
      if (!@group.nil?)
        @group.parties << @party
      end
      render 'show'
    else
      redirect_to(root_path)
    end
  end

  private

  def authenticate
    redirect_to(root_path) unless signed_in?
  end

end
