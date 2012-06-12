module NotificationsHelper
  def to_datetime(ms_since_epoch, zone)
    Time.at(ms_since_epoch.to_i / 1000).in_time_zone(-1 * zone.minutes).to_datetime
  end
  
  def format_date(ms_since_epoch, zone)
    to_datetime(ms_since_epoch, zone).strftime('%l:%M %P').strip
  end
  
  def facebook_avatar_url(facebook_id)
    "https://graph.facebook.com/#{facebook_id}/picture?type=square"
  end
  
  def game_introduction(user, team, game)
    message = "Hey #{user[:name]}, you have a game with <strong>#{team[:name]}</strong> #{game[:tomorrow] ? 'tomorrow' : 'today'}. ".html_safe
    message
  end
  
  def game_summary(team, game, html)
    message = "
    <dl>
    <dt>Team:</dt><dd>#{team[:name]}</dd>
    <dt>Date:</dt><dd>#{game[:tomorrow] ? 'tomorrow' : 'today' }</dd>
    <dt>Time:</dt><dd>#{format_date(@game[:date], @game[:zone])}</dd>
    <dt>Location:</dt><dd>#{@game[:location]}</dd>
    <dt>Note:</dt><dd class='red'>#{game_error(@game)}</dd>
    </dl>
    ".html_safe
    
    message_plain = "
    Team:#{team[:name]}
    Date:#{game[:tomorrow] ? 'tomorrow' : 'today' }
    Time:#{format_date(@game[:date], @game[:zone])}
    Location:#{@game[:location]}
    Note:#{game_error(@game)}
    "
    if html
      message
    else
      message_plain
    end
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
  
  def game_error(game)
    return unless game[:player_deficit] > 1
    
    message = "#{game[:player_deficit]} more players are needed to field"
    
    "#{message} this team"
  end
  
  def player_state(game, html)
    if game[:player_state].to_sym == :playing
      message = "You are playing."
      links = [["Click if that's incorrect"], game[:unconfirmed_url]]
    elsif game[:player_state].to_sym == :not_playing
      message = "You aren't playing."
      links = [["Click if that's incorrect"], game[:unconfirmed_url]]
    else
      message = "Confirm whether you're playing by clicking on the buttons below."
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