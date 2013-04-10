class MicropostsController < ApplicationController
before_filter :sign_in_user,	only: [:create,:destroy]
before_filter :correct_user,	only: :destroy

	def index
		
	end

	def create
		# binding.pry
		@micropost = current_user.microposts.create(params[:micropost])
		if @micropost.save
			flash[:success] = "Create micropost success."
			redirect_to root_path
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		# binding.pry		
		@micropost.destroy
		flash[:success] = "#{current_user.name} destroy micropost #{params[:id]}"
		redirect_to root_path
	end

	private
	def correct_user
		binding.pry
		@micropost = current_user.microposts.find_by_id(params[:id])
		redirect_to root_url if @micropost.nil?
	end
end