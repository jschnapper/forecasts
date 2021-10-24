class ExportsController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_params

  # export and download
  def create
    name = "#{@team.name.parameterize.underscore}_#{@team_monthly_forecast.date.strftime("%Y_%m")}_forecast_#{Time.now.strftime('%Y%m%dT%H%M%S')}"
    if params[:export_type].to_i == 1
      render xlsx: name, template: 'exports/forecast.xlsx.axlsx'
    elsif params[:export_type].to_i == 2
      render xlsx: name, template: 'exports/forecast_row_per_field.xlsx.axlsx'
    end
  end
  
  private

  def set_params
    @team = Team.find_by(slug: params[:team_name])
    @team_monthly_forecast = TeamMonthlyForecast.find_by(id: params[:team_monthly_forecast_id])
  end
end