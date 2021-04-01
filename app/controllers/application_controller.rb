class ApplicationController < ActionController::API
	# skip_before_action :verify_authenticity_token

  before_action :authenticate_user!
end
