module GamesHelper
  include NotificationsHelper
  
  def to_calendar(team_name, games)
    calendar = Icalendar::Calendar.new
    games.each do |id, game|
      logger.warn(game.inspect)
      
      start = to_datetime(game['date'].to_i, game['zone'].to_i)
      calendar.event do
        summary "#{team_name} Game"
        description game['location'] if game['location']
        dtstart start
        dtend start + 1.hour
      end
    end
    
    calendar
  end
end
