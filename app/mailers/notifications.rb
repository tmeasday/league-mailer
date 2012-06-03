class Notifications < ActionMailer::Base
  default from: "us@percolatestudio.com"
  
  def test(data)
    @data = data
    mail :to => 'tom@thesnail.org', :subject => "Test mail from league-mailer"
  end
end
