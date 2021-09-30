require 'csv'

class CreateCsv < ApplicationService

  def initialize(team, monthly_forecast)
    @team = team
    @monthly_forecast = monthly_forecast
  end

  def call
    execute
  end

  private

  attr_accessor :team, :monthly_forecast

  def execute
    begin
      file = Tempfile.new("#{team.name.parameterize.underscore}_#{monthly_forecast.friendly_name.parameterize.underscore}")
      headers = ['first name', 'last name', 'email', 'total hours']
      headers << 'holiday' if monthly_forecast.has_holidays?
      headers += team.ordered_fields.map { |field| field.name.downcase }.excluding("holiday")
      headers << "notes"
      csv = CSV.new(file, headers: headers, skip_lines: '#')
      csv << ["# #{monthly_forecast.friendly_name}"]
      csv << ["# Expected total hours: #{monthly_forecast.total_hours}"]
      csv << ["# Expected holiday hours: #{monthly_forecast.holiday_hours}"]
      csv << headers 
      member_forecasts = MemberForecast.get_member_forecasts(team, monthly_forecast)
      member_forecasts.each do |member_forecast|
        row = []
        row << member_forecast.first_name
        row << member_forecast.last_name
        row << member_forecast.email
        row << member_forecast.total_hours
        if monthly_forecast.has_holidays?
          row << member_forecast.hours&.fetch(:holiday, 0)
        end
        team.ordered_fields.each do |field|
          if field.name != "holiday"
            val = member_forecast&.hours&.fetch(field.name).present? ? member_forecast&.hours&.fetch(field.name) : 0
            row << val
          end
        end
        row << member_forecast.notes
        csv << row
      end
    ensure
      file.close
    end

    return file
  end
end