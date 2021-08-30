# frozen_string_literal: true

# Preview forecast emails
class ForecastMailerPreview < ActionMailer::Preview
  def confirmation_email
    ForecastMailer.confirmation_email(MemberForecast.first)
  end
end