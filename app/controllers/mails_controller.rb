class MailsController < ApplicationController
  def create
    Notifications.test(params[:data]).deliver
    head :ok
  end
end
