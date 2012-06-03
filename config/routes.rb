LeagueMailer::Application.routes.draw do
  # TODO remove index
  resources :mails, :only => [:index, :create]
end
