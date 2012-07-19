# grab a list of games from a meteor server
module LeagueServer
  
  # pretty simplistic, but it seems to work
  def self.get_games(team_ids)
    games = nil
    EM.run do
      league_client = if ::Rails.env.production?
        RubyDdp::Client.new('beta.getleague.com', 80)
      else
        RubyDdp::Client.new('localhost', 3000)
      end
      
      league_client.onconnect = lambda do |event|
        league_client.subscribe('games', [team_ids]) do |result|
          games = league_client.collections['games']
          EM.stop_event_loop
        end
      end
    end
    
    games
  end
end

