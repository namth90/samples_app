class UserMailer < ActionMailer::Base
  default from: "namth90@gmail.com"

  def welcome_email(user)
  	# binding.pry
  	@user = user
  	# @url = "http://ruby.railstutorial.org/chapters"
  	mail(:to => user.email, :subject => "Welcome to email")
  end

  def password_reset(user)
  	@user = user
  	mail(:to => user.email, :subject => "Password reset.")
  end
end
