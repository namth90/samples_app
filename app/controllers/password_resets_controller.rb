class PasswordResetsController < ApplicationController

	def new
		
	end
# def send_password_reset
# 	@user.password_reset_token = SecureRandom.urlsafe_base64
# 	@user.password_reset_send_at = Time.zone.now
# 	UserMailer.password_reset(@user).deliver
# end
	def create
		# binding.pry
		@user = User.find_by_email(params[:email])
		if @user
			@user.send_password_reset			
			# redirect_to edit_password_reset_path
			flash[:notice] = "Please you email reset password!!!"
			redirect_to signin_path
		else
			flash.now[:notice] = "No account was found with that email address!!!"
			render new_password_reset_path
		end		
	end

	def edit
		# binding.pry	
		@user = User.find_by_password_reset_token(params[:id])
	end

	def update
		# binding.pry
		@user = User.find_by_password_reset_token(params[:id])
		if @user.password_reset_send_at < 2.hours.ago
			flash[:error] = "Reset password has expired"
			redirect_to new_password_reset_path
		elsif @user.update_attributes(params[:user])
			flash[:success] = "Reset password succu!!!"
			redirect_to signin_path
		else
			flash[:error] = "Error"
			render 'edit'
		end
	end
end
