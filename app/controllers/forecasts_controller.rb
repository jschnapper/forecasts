class ForecastsController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_team,
                :set_monthly_forecast

  # /manage/:team_name/forecasts
  def index
    @monthly_forecasts = MonthlyForecast.order(date: :desc).first(12)
  end

  # /manage/:team_name/:year/:month
  def show
    @member_forecasts = MemberForecast.get_member_forecasts(@team, @monthly_forecast)
  end

  private

  # set team
  def set_team
    @team = Team.find_by(slug: params[:team_name]) if @team.nil?
  end

  def set_monthly_forecast
    if params[:year] && params[:month]
      @monthly_forecast = MonthlyForecast.find_by(date: Date.parse("#{params[:year]}/#{params[:month]}"))
      if @monthly_forecast.nil?
        redirect_to new_team_forecast_path
      end
    elsif params[:year].nil? && params[:month].nil?
      date = Date.today
      @monthly_forecast = MonthlyForecast.find_by(date: Date.parse("#{date.year}/#{date.strftime('%B')}")) || MonthlyForecast.active.last
    elsif params[:year] || params[:month]
      # if only one param provided, redirect to forecasts
      redirect_to action: :index, team_name: @team&.name
    end 
  end
end
