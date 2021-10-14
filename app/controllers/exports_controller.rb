class ExportsController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_params

  # export and download
  def create
    render xlsx: "#{@team.name.parameterize.underscore}_#{@monthly_forecast.date.strftime("%Y_%m")}_forecast_#{Time.now.strftime('%Y%m%dT%H%M%S')}", template: 'exports/forecast.xlsx.axlsx'
  end
  
  private

  def set_params
    @team = Team.find_by(slug: params[:team_name])
    @monthly_forecast = MonthlyForecast.find_by(id: params[:monthly_forecast_id])
  end
end