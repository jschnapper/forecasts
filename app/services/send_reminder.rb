class SendReminder < ApplicationService
  
  def initialize(teams, monthly_forecast, message=nil, members: nil)
    @teams = teams
    @monthly_forecast = monthly_forecast
    @message = message
  end

  def call
    execute
  end

  private

  attr_reader :teams, :monthly_forecast, :message

  def execute
    forecasts = MemberForecast.get_member_forecasts(teams, monthly_forecast).select { |member| member.hours.nil? || member.hours == 0 }
    Member.includes(:teams).where(id: forecasts.map(&:id)).each do |member|
      ReminderMailer.reminder(member, monthly_forecast, message).deliver_now
    end
  end
end