class ExportsController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_params

  # export and download
  def create
    render xlsx: "#{@team.name.parameterize.underscore}_#{@team_monthly_forecast.date.strftime("%Y_%m")}_forecast_#{Time.now.strftime('%Y%m%dT%H%M%S')}", template: 'exports/forecast.xlsx.axlsx'
  end
  
  private

  def set_params
    @team = Team.find_by(slug: params[:team_name])
    @team_monthly_forecast = TeamMonthlyForecast.find_by(id: params[:team_monthly_forecast_id])
  end
end