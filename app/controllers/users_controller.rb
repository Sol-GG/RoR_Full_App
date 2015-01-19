class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
	@user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Successfuly updated info"
      redirect_to @user
    else
      render 'edit'
    end
  end

  
  def create
    @user = User.new(user_params)
    if @user.save
	    flash[:success] = "Welcome to the Sample App!"
      sign_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end


    # Before filters


    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:notice] = "Please sign in."
        redirect_to(root_url) 
      end
    end	

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
