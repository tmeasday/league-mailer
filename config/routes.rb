LeagueMailer::Application.routes.draw do
  resources :mails, :only => [:create, :show]
  
  resources :teams, :only => [] do
    resources :games, :only => :index
  end
end
