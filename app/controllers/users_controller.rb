class UsersController < ApplicationController
  before_filter :sign_in_user,only: [:edit,:update,:index]
  before_filter :correct_user,only: [:edit,:update]

  def index
    # binding.pry
    @users = User.paginate(page: params[:page])
  end

	def show
		@user = User.find(params[:id])
	end

  def new
  	@user = User.new
  end

  def edit
    # binding.pry
    @user = User.find(params[:id])
  end

  def update
    # binding.pry
    @user =  User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.now[:success] = "Profile update success."
      sign_in(@user)
      redirect_to @user
    else
      flash.now[:error] =  "Error..."
      render 'users/edit'
    end
  end

  def create
  	# binding.pry
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

  def destroy
    # binding.pry
    @user = User.find(params[:id])
    if @user.delete
      flash[:notice] = "#{@user.name} have id #{params[:id]} delete!!!"
      redirect_to users_path
    end
  end

  def active
    # binding.pry
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

  private
  
  def sign_in_user
    # binding.pry
    # redirect_to signin_url, notice:"Please sign in." unless signed_in?
    if !signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_path
    end    
  end

  def correct_user
    # binding.pry
    @user = User.find(params[:id])
    if !current_user?(@user)
      redirect_to root_path
    end
  end
end
