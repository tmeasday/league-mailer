class Notifications < ActionMailer::Base
  layout 'email'
  default from: "us@percolatestudio.com"
  
  def signup(data)
    @base_url = data[:base]
    @user = data[:user]
    mail :to => "#{@user[:name]} <#{@user[:email]}>", :subject => "Welcome to League"
  end
  
  def season_ticket(data)
    @base_url = data[:base]
    @user = data[:user]
    @team = data[:team]
    @players = data[:team][:players]
    mail :to => "#{@user[:name]} <#{@user[:email]}>", :subject => "#{@team[:name]} League Season Ticket"
  end
  
  def reminder(data)
    @base_url = data[:base]
    @user = data[:user]
    @team = data[:team]
    @game = data[:game]
    
    mail :to => "#{@user[:name]} <#{@user[:email]}>", :subject => "Upcoming game for #{@team[:name]}"
  end
end
