class SessionsController < ApplicationController
	def new
		@user = User.new
	end

	def create
		binding.pry
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.status != true			
			flash[:error] = "Account haven't active ?"			
			redirect_to signin_path
			else
				flash[:success] = "Account active and Sign in Success!!!"
				sign_in user
				redirect_to user
			end
		else
			flash.now[:error] = "Invalid email or password ?"
			render 'new'			
		end		
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
