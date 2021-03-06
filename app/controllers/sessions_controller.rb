class SessionsController < ApplicationController
	before_action :authorized, only: [:auto_login]
	
	# REGISTER
	def create
		@user = User.create(user_params)
		if @user.valid?
			token = encode_token({user_id: @user.id})
			render json: {token: token}
		else
			render json: {error: "Invalid username or password"}, status: :bad_request
		end
	end
	
	# LOGGING IN
	def login
		@user = User.find_by(email: params[:email])
		
		if @user && @user.authenticate(params[:password])
			token = encode_token({user_id: @user.id})
			render json: {token: token}
		else
			render json: {error: "Invalid username or password"}, status: :bad_request
		end
	end
	
	
	def auto_login
		render json: { user: @user }
	end
	
	private
	
	def user_params
		params.permit(:email, :password)
	end

end
