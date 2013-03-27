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
  	if @user.save
  		# Handle a successful save.
  		# redirect_to user_path(@user)
  		flash[:success] = "Wellcom to the Sample App!"
  		redirect_to @user
  	else
      flash[:error] = "Errors!!!"
  		render 'new'
  	end
  end
end
