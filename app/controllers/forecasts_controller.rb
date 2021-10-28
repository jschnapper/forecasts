class ForecastsController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_team,
                :set_team_monthly_forecast

  # /manage/:team_name/forecasts
  def index
    @team_monthly_forecasts = TeamMonthlyForecast.includes(:monthly_forecast).where(team_id: team.id).order("monthly_forecasts.date DESC").last(12)
  end

  # /manage/:team_name/:year/:month
  def show
    @member_forecasts = MemberForecast.get_member_forecasts(@team, @team_monthly_forecast.monthly_forecast)
  end

  def update
  end

  private

  def team
    @team ||= Team.find_by(slug: params[:team_name])
  end

  def set_team
    team
  end

  def set_team_monthly_forecast
    if params[:year] && params[:month]
      @team_monthly_forecast = TeamMonthlyForecast.joins(:monthly_forecast).find_by(team_id: team.id, monthly_forecasts: { date: Date.parse("#{params[:year]}/#{params[:month]}")})
      if @team_monthly_forecast.nil?
        redirect_to new_team_forecast_path
      end
    elsif params[:year].nil? && params[:month].nil?
      date = Date.today
      @team_monthly_forecast = TeamMonthlyForecast.joins(:monthly_forecast).find_by(team_id: team.id, monthly_forecasts: { date: Date.parse("#{date.year}/#{date.strftime('%B')}")}) || TeamMonthlyForecast.where(team_id: team.id).open_forecasts&.last
    elsif params[:year] || params[:month]
      # if only one param provided, redirect to forecasts
      redirect_to action: :index, team_name: @team&.name
    end 
  end
end
