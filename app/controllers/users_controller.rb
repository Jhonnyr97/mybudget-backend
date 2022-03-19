class UsersController < ApplicationController
	before_action :authorized
	def index
		render json: "ok"
	end
end
