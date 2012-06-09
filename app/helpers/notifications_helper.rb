module NotificationsHelper
  def to_datetime(ms_since_epoch)
    Time.at(ms_since_epoch.to_i / 1000).to_datetime
  end
  
  def format_date(ms_since_epoch)
    to_datetime(ms_since_epoch).strftime('%l:%M %P').strip
  end
  
  def facebook_avatar_url(facebook_id)
    "https://graph.facebook.com/#{facebook_id}/picture?type=square"
  end
  
  def game_introduction(user, game)
    message = "Hey #{user[:name]},\n   you have a game #{game[:tomorrow] ? 'tomorrow' : 'today'} at #{format_date(game[:date])}. "
    message += "It's at #{game[:location]}." if game[:location]
    message
  end
  
  def game_tomorrow(game)
    if game[:tomorrow]
      "Game Tomorrow"
    else
      "Today's Game"
    end
  end
  
  def game_state(game, html)
    if game[:team_state].to_sym == :need_players
      message = "#{game[:player_deficit]} players needed"
      color = 'red'
    elsif game[:team_state].to_sym == :unconfirmed
      message = "#{game[:unconfirmed_count]} players still unconfirmed"
      color = 'yellow'
    else
      message = "Ready to play! (#{game[:playing_count]} playing)."
      color = 'green'
    end
    
    if html
      "<span class='#{color}'>#{message}</span>".html_safe
    else
      message
    end
  end
  
  def game_error(game, html)
    return unless game[:player_deficit] > 1
    
    message = "#{game[:player_deficit]} more players are needed to field"
    
    if html
      "#{message} <strong>#{@team[:name]}</strong>".html_safe
    else
      "#{message} #{@team[:name]}."
    end
  end
  
  def player_state(game, html)
    if game[:player_state].to_sym == :playing
      message = "You are confirmed playing."
      links = [["Click if that's incorrect"], game[:unconfirmed_url]]
    elsif game[:player_state].to_sym == :not_playing
      message = "You aren't playing."
      links = [["Click if that's incorrect"], game[:unconfirmed_url]]
    else
      message = "You haven't confirmed if you are playing yet."
      links = [["Click here if you can play", game[:playing_url]],
               ["Click here if you can't", game[:not_playing_url]]]
    end
    
    if html
      link_text = links.map do |data|
        content_tag :li do
          link_to data[0], data[1]
        end
      end.join('')
        
      "#{message} <ul>#{link_text}</ul>".html_safe
    else
      link_text = links.map {|data| "#{data[0]}: #{data[1]} "}.join("\n\n")
      "#{message}\n\n#{link_text}"
    end
  end
end