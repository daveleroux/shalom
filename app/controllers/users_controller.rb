class UsersController < ApplicationController
  before_filter :correct_user, :only => [:show]
  before_filter :admin_user_or_correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:index, :new, :create, :destroy]

  def index
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Created new user"
      redirect_to new_user_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if (!admin?)
      params[:user].delete(:admin)
    end
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private

  #def authenticate
  #deny_access unless signed_in?
  #redirect_to(root_path) unless signed_in?
  #end

  def idMatchCurrentUser?
    current_user?(User.find(params[:id]))
  end

  def correct_user
    redirect_to(root_path) unless signed_in? && idMatchCurrentUser?
  end

  def admin_user_or_correct_user
    redirect_to(root_path) unless signed_in? && (current_user.admin? || idMatchCurrentUser?)
  end

  def admin_user
    redirect_to(root_path) unless signed_in? && current_user.admin?
  end
end
