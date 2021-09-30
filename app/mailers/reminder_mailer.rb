class ReminderMailer < ApplicationMailer
  default template_path: 'reminders/reminder_mailer'

  def reminder(member, monthly_forecast, message)
    @team = member.teams&.first
    @member = member
    @monthly_forecast = monthly_forecast
    @message = message
    mail(
      to: member.email,
      subject: "[ACTION REQUIRED] Submit #{monthly_forecast.friendly_name} forecast"
    )
  end
end