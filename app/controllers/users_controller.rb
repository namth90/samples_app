class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
	end

  def new
  	@user = User.new
  end

  def create
  	binding.pry
  	@user = User.new(params[:user])
    @user.login = SecureRandom.urlsafe_base64
  	if @user.save
      UserMailer.welcome_email(@user).deliver
      sign_in @user
  		flash[:success] = "Please you active account!"
  		redirect_to signin_path 
  	else
      flash.now[:error] = "error"
  		render 'new'
  	end
  end

  def active
    binding.pry
    @user = User.find(params[:id])
    if @user.login == params[:active_code]
      if @user.status != true
        @user.update_attribute(:status,true)
        flash[:success] = "You active account success!"
        redirect_to signin_path
      else
        redirect_to signin_path
      end
    else
      flash[:error] = "error!!!"
      render signin_path
    end
  end
end
