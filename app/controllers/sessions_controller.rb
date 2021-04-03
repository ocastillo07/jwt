class SessionsController < Devise::SessionsController
  respond_to :json

  private

    def respond_with(resourse, opts = {})
      render json: resourse
    end

    def respond_to_on_destroy
      head :no_content
    end
end