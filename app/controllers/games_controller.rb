require ::Rails.root.join('lib', 'league_server')

class GamesController < ApplicationController
  def index
    @team_name = params['team_name']
    @games = LeagueServer.get_games([params[:team_id]])
  end
end
