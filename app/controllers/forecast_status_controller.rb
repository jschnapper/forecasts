class ForecastStatusController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_team_monthly_forecast


  def update
    status = params[:status]&.to_i == 1
    @team_monthly_forecast.update(open_for_submissions: status)
    redirect_back fallback_location: home_path
  end

  private

  def set_team_monthly_forecast
    @team_monthly_forecast = TeamMonthlyForecast.includes(:team, :monthly_forecast).find_by(id: params[:team_monthly_forecast_id])
  end

end