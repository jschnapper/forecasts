class ExportsController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_params

  # export and download
  def create
    csv_file = CreateCsv.call(@team, @monthly_forecast)
    send_file csv_file.path, filename: "#{@team.name.parameterize.underscore}_#{@monthly_forecast.date.strftime("%m_%Y")}_forecast_#{Time.now.strftime('%Y%m%dT%H%M%S')}.csv"
  end

  private

  def set_params
    @team = Team.find_by(slug: params[:team_name])
    @monthly_forecast = MonthlyForecast.find_by(id: params[:monthly_forecast_id])
  end
end