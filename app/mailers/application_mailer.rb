class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@sheffield.ac.uk"
  layout "mailer"

  def send_contact_email(info)
    @info = info
    mail(to: 'team22@sheffield.ac.uk', subject: 'New Contact Message') do |format|
      format.text
    end
  end
end