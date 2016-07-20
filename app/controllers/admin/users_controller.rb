class Admin::UsersController < ApplicationController
  def index
  	@users = User.all.page(params[:page]).per(3)
    if !current_user || current_user.is_admin == false
      redirect_to movies_path, notice: "You are not an Admin"
    end
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	@user.update(is_admin: true)
    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end

end
