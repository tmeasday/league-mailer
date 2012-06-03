class MailsController < ApplicationController
  def create
    mail = params[:mail].to_sym
    data = ActiveSupport::JSON.decode(params[:data]).with_indifferent_access
    
    Notifications.send(mail, data).deliver
    head :ok
  end
end
