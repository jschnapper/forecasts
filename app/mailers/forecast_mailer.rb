# frozen_string_literal: true

# Mailer for forecast confirmations and reminders
class ForecastMailer < ApplicationMailer

  # Confirmation email for when user submits forecast
  # @param [MemberForecast] member_forecast_submission - instance of MemberForecast
  def confirmation_email(member_forecast_submission)
    @member_forecast = member_forecast_submission
    @team_monthly_forecast = member_forecast_submission.team_monthly_forecast
    @monthly_forecast = @team_monthly_forecast.monthly_forecast
    @team = @team_monthly_forecast.team
    @member = member_forecast_submission.member
    mail(
      to: @member.email,
      subject: "Your #{@monthly_forecast.friendly_name} Submission"
    )
  end
end
