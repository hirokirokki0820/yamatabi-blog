class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:mail, :sender_address)
  layout "mailer"
end
