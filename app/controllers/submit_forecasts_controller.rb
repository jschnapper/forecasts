class SubmitForecastsController < ApplicationController
  before_action :set_team_by_name, :set_monthly_forecast, only: :new
  before_action :prepare_member_forecast, only: :create

  # root
  # /forecasts
  # /forecasts/:team_name/:year/:month
  def new
    @member_forecast = MemberForecast.new
    # Load all teams even if have team already
    # in order to seed dropdown
    @teams = Team.all
    @members = @team&.members
    respond_to do |format|
      format.html { render :new }
      format.js { render :form_ajax, locals: { team: @team, monthly_forecast: @monthly_forecast, member_forecast: @member_forecast } }
    end
  end

  def create
    existing_submission = MemberForecast.find_by(
      monthly_forecast_id: params[:member_forecast][:monthly_forecast_id],
      team_id: params[:member_forecast][:team_id],
      member_id: params[:member_forecast][:member_id]
    )
    if existing_submission
      @member_forecast = existing_submission.update(hours: member_forecast_params[:hours])
    else
      @member_forecast = MemberForecast.create(member_forecast_params)
    end
    render :success
  end

  private

  def member_forecast_params
    params.require(:member_forecast).permit(:member_id, :team_id, :monthly_forecast_id, hours: [team&.fields&.map { |field| field.name.downcase }])
  end

  # memoized field fetch
  def team
    @team ||= Team.includes(:fields).find_by(id: params.dig(:member_forecast, :team_id))
  end

  # set using path params
  # on NEW
  def set_team_by_name
    if params[:team_name].present?
      # in case of whitespace, add dash for saerching slug
      name = params[:team_name].strip.downcase.tr(' ', '-')
      @team = Team.includes(:members).find_by('lower(slug) = ?', name)
    end
  end

  # set using path params
  # on NEW
  def set_monthly_forecast
    if params[:year] && params[:month]
      @monthly_forecast = MonthlyForecast.find_by(date: Date.parse("#{params[:year]}/#{params[:month]}"))
      if @monthly_forecast.nil?
        redirect_to new_team_forecast_path
      end
    elsif params[:year] || params[:month]
      # if only one param provided, redirect to forecasts
      redirect_to new_team_forecast_path, team_name: @team&.name
    else
      # get most recent forecast
      @monthly_forecast = MonthlyForecast.last
    end
  end

  # set from form submission
  # on CREATE
  def prepare_member_forecast
    # 
  end
end
