class ApplicationController < ActionController::Base
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['USER_NAME'] || 'test' && password == ENV['PASSWORD'] || 'test'
    end
  end
end
