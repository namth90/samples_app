module SessionsHelper

	def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end


  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end


  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in?
      !current_user.nil?
  end

  def sign_out
  	self.current_user = nil
  	cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    # binding.pry
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    # binding.pry
    session[:return_to] = request.url
  end

  def sign_in_user
    # binding.pry
    # redirect_to signin_url, notice:"Please sign in." unless signed_in?
    if !signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_path
    end    
  end
end


