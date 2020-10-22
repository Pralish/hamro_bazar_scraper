# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_error

  def handle_error(error)
    render json: { success: false, message: error.message }, status: 422
  end
end
