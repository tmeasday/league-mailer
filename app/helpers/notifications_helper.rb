module NotificationsHelper
  def format_date(ms_since_epoch)
    Time.at(ms_since_epoch.to_i / 1000).to_datetime.to_formatted_s(:long_ordinal)
  end
  
  def facebook_avatar_url(facebook_id)
    "https://graph.facebook.com/#{facebook_id}/picture?type=square"
  end
end