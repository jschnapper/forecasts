# frozen_string_literak: true

class SubmitForecastsController < ApplicationController
  before_action :set_team,
                :set_team_monthly_forecast,
                :set_member,
                only: :new

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
      format.js {
        render :form_ajax,
          locals: {
            team: @team,
            team_monthly_forecast: @team_monthly_forecast,
            member_forecast: @member_forecast,
            member: @member
          }
        }       
    end
  end

  def create
    existing_submission = MemberForecast.includes(:member, team_monthly_forecast: :team).find_by(member_id: params[:member_forecast][:member_id], team_monthly_forecast_id: params[:member_forecast][:team_monthly_forecast_id])
    @team_monthly_forecast = TeamMonthlyForecast.find_by(id: params.dig(:member_forecast, :team_monthly_forecast_id), open_for_submissions: true)
    if @team_monthly_forecast
      if existing_submission
        existing_submission.update(hours: member_forecast_params[:hours], notes: member_forecast_params[:notes])
        @member_forecast = existing_submission
      else
        @member_forecast = MemberForecast.create(member_forecast_params)
      end
    end
    @member = @member_forecast.member
    @team = @member_forecast.team_monthly_forecast.team
    if @member_forecast.errors.present?
      # need all members for dropdown
      @members = @team&.members
      render :new
    else
      ForecastMailer.confirmation_email(@member_forecast).deliver_now
      render :success
    end
  end

  private

  def member_forecast_params
    params.require(:member_forecast).permit(:member_id, :team_monthly_forecast_id, :notes, hours: [team&.fields&.map { |field| field.name }])
  end

  # memoized field fetch
  def team
    @team ||= set_team
  end

  # set using team_name path params or team_id query param
  # on NEW
  def set_team
    if params[:team_name].present?
      # in case of whitespace, add dash for saerching slug
      name = params[:team_name].strip.downcase.tr(' ', '-')
      @team = Team.includes(:members).find_by('lower(slug) = ?', name)
    elsif params[:team_id].present?
      @team = Team.includes(:members).find_by(id: params[:team_id])
    elsif params.dig(:member_forecast,:team_monthly_forecast_id)
      @team = TeamMonthlyForecast.find_by(id: params[:member_forecast][:team_monthly_forecast_id])&.team
    end
  end

  # set using path params
  # on NEW
  def set_team_monthly_forecast
    if params[:year] && params[:month]
      @monthly_forecast = MonthlyForecast.includes(:team_monthly_forecasts).find_by(date: Date.parse("#{params[:year]}/#{params[:month]}"))
      if @monthly_forecast.nil?
        redirect_to new_team_forecast_path
      end
    elsif params[:year] || params[:month]
      # if only one param provided, redirect to forecasts
      redirect_to new_team_forecast_path, team_name: @team&.name
    else
      # get current forecast
      # Date
      @monthly_forecast = MonthlyForecast.find_by(date: Time.zone.today.beginning_of_month) || MonthlyForecast.last
    end
    @team_monthly_forecast = @monthly_forecast.team_monthly_forecasts.detect { |tmf| tmf.team_id == @team&.id }
  end

  # set using member_id param
  def set_member
    @member = team&.members&.find_by(id: params[:member_id])
  end
end
