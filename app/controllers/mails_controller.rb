class MailsController < ApplicationController
  def index
    logger.warn "Woo, index called"
    head :ok
  end
  
  def create
    # TODO -- actually send an email
  end
end
