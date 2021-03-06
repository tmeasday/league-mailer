module NotificationsHelper
  def to_datetime(ms_since_epoch, zone)
    Time.at(ms_since_epoch.to_i / 1000).in_time_zone(-1 * zone.minutes).to_datetime
  end
  
  def format_time(ms_since_epoch, zone)
    to_datetime(ms_since_epoch, zone).strftime('%l:%M %P').strip
  end
  
  def date_word(ms_since_epoch, zone, prefix = '')
    date = to_datetime(ms_since_epoch, zone)
    now = Time.now.in_time_zone(-1 * zone.minutes)
    
    
    if date.day == now.day
      'Today'
    elsif date.day - now.day == 1
      'Tomorrow'
    else
      prefix + ' ' + date.strftime('%A')
    end
  end
  
  
  def facebook_avatar_url(facebook_id)
    "https://graph.facebook.com/#{facebook_id}/picture?type=square"
  end
  
  def game_introduction(user, team, game, html = true)
    name = team[:name]
    name = "<strong>#{name}</strong>" if html
    message = "Hey #{user[:name]}, you have a game with #{name} #{date_word(game[:date], game[:zone], 'on')}. ".html_safe
    message
  end
  
  def game_summary(team, game, html)
    message = "
    <dl>
    <dt>Team:</dt><dd>#{team[:name]}</dd>
    <dt>Date:</dt><dd>#{date_word(game[:date], game[:zone], 'This')}</dd>
    <dt>Time:</dt><dd>#{format_time(game[:date], game[:zone])}</dd>
    <dt>Location:</dt><dd>#{game[:location]}</dd>
    <dt>Note:</dt><dd class='red'>#{game_error(game)}</dd>
    </dl>
    ".html_safe
    
    message_plain = "
    Team:#{team[:name]}
    Date:#{date_word(game[:date], game[:zone], 'This')}
    Time:#{format_time(game[:date], game[:zone])}
    Location:#{game[:location]}
    Note:#{game_error(game)}
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
    return unless game[:player_deficit] > 0
    
    message = "#{game[:player_deficit]} more players are needed to field"
    
    "#{message} this team"
  end
  
  def player_state_message(state)
    state = state.downcase.to_sym
    if state == :playing
      "You are playing."
    elsif state == :not_playing
      "You aren't playing."
    end
  end
end