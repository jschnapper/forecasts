# frozen_string_literak: true

class SubmitForecastsController < ApplicationController
  before_action :set_team,
                :set_monthly_forecast,
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
            monthly_forecast: @monthly_forecast,
            member_forecast: @member_forecast,
            member: @member
          }
        }
    end
  end

  def create
    existing_submission = MemberForecast.includes(:member, :team, :monthly_forecast).find_by(
      monthly_forecast_id: params[:member_forecast][:monthly_forecast_id],
      team_id: params[:member_forecast][:team_id],
      member_id: params[:member_forecast][:member_id]
    )
    if existing_submission && existing_submission.monthly_forecast.active
      existing_submission.update(hours: member_forecast_params[:hours], notes: member_forecast_params[:notes])
      existing_submission.reload
      @member_forecast = existing_submission
      @monthly_forecast = existing_submission.monthly_forecast
      @member = existing_submission.member
      @team = existing_submission.team
    else
      @member_forecast = MemberForecast.create(member_forecast_params)
      @monthly_forecast = MonthlyForecast.find_by(id: params.dig(:member_forecast, :monthly_forecast_id), active: true)
      @member = Member.find_by(id: params.dig(:member_forecast, :member_id))
      @team = Team.find_by(id: params.dig(:member_forecast, :team_id))
    end
    ForecastMailer.confirmation_email(@member_forecast).deliver_now
    render :success
  end

  private

  def member_forecast_params
    params.require(:member_forecast).permit(:member_id, :team_id, :monthly_forecast_id, :notes, hours: [team&.fields&.map { |field| field.name.downcase }])
  end

  # memoized field fetch
  def team
    @team ||= Team.includes(:members, :fields).find_by(id: params.dig(:member_forecast, :team_id))
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

  # set using member_id param
  def set_member
    @member = team&.members&.find_by(id: params[:member_id])
  end
end
