module NotificationsHelper
  def format_date(ms_since_epoch)
    Time.at(ms_since_epoch.to_i / 1000).to_datetime.to_formatted_s(:long_ordinal)
  end
end