class SubmitForecastsController < ApplicationController
  before_action :set_team
  before_action :set_forecast

  # root
  # /forecasts
  # /forecasts/:team_name/:year/:month
  def new
    @teams = Team.all
    @members = @team.nil? ? Member.all : @team.members
    respond_to do |format|
      format.html { render :new }
      format.js { render :form_ajax, locals: { team: @team } }
    end
  end

  def create
  # To do
  end

  private

  def set_team
    if params[:team_name].present?
      # in case of whitespace, add dash for saerching slug
      name = params[:team_name].strip.downcase.tr(' ', '-')
      @team = Team.includes(:members).find_by('lower(slug) = ?', name)
    end
  end

  def set_forecast
    if params[:year] && params[:month]
      @monthly_forecast = MonthlyForecast.find_by(date: Date.parse("#{params[:year]}/#{params[:month]}"))
    elsif params[:year] || params[:month]
      # if only one param provided, redirect to forecasts
      redirect_to new_team_forecast_path, team_name: @team&.name
    else
      # get most recent forecast
      @monthly_forecast = MonthlyForecast.last
    end
  end
end
