class MailsController < ApplicationController
  before_filter :authenticate, :only => :create
  
  def create
    mail = params[:mail].to_sym
    data = ActiveSupport::JSON.decode(params[:data]).with_indifferent_access
    
    Notifications.send(mail, data).deliver
    head :ok
  end
  
  def show
    prepare_email(params[:id])
    
    PremailerRails::Hook.delivering_email(@mail)
    @page_title = @mail.subject
    if params[:part] == 'css'
      render :template => @html_template, :layout => 'email'
    elsif params[:part] == 'html'
      render :text => @mail.html_part.body
    else
      plain = @mail.parts.find {|p| p.content_type =~ /text\/plain/ }
      render :text => '<pre>' + @mail.text_part.body.to_s + '</pre>'
    end
  end
protected
  def prepare_email(type)
    self.send "prepare_#{type.to_s}".to_sym
  end
  
  def setup_user
    @user = {:name => 'Tom Coleman', :email => 'tom@thesnail.org'}
  end
  
  def setup_team
    @players = [
      {:name => 'Tom Coleman', :facebook_id => '680541486'},
      {:name => 'Ian Stuart', :facebook_id => '1202505'}
    ]
    @team = {:name => "Tom's Fault", :url => 'http://foo.bar',
      :players => @players
    }
  end
  
  def setup_game
    @game = {:location => "Brunswick", 
      :date => (DateTime.now + 1.hours).to_i * 1000, 
      :zone => -600,
      :tomorrow => false,
      :player_state => 'unconfirmed',
      :team_state => 'unconfirmed',
      :confirmation_count => 3,
      :playing_count => 2,
      :player_deficit => 2, 
      :playing_url => 'foo.bar/playing', :not_playing_url => 'foo.bar/not_playing', 
      :unconfirmed_url => 'foo.bar/unconfirmed'}
  end
  
  def prepare_signup
    setup_user
    @html_template = 'notifications/signup.html.erb'
    @mail = Notifications.signup({user: @user})
  end
  
  def prepare_season_ticket
    setup_user
    setup_team
    @html_template = 'notifications/season_ticket.html.erb'
    @mail = Notifications.season_ticket({user: @user, team: @team})
  end
  
  def prepare_reminder
    setup_user
    setup_team
    setup_game
    @html_template = 'notifications/reminder.html.erb'
    @mail = Notifications.reminder({user: @user, team: @team, game: @game})
  end
end
