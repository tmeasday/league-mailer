LeagueMailer::Application.routes.draw do
  resources :mails, :only => :create
end
