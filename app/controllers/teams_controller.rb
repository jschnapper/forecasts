# frozen_string_literal: true
class TeamsController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }, except: [:index, :create, :destroy]
  before_action -> { requires_at_least_role :admin }, only: [:index, :create, :destroy]

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if Team.create(team_params)
      redirect_to @team
    else
      render :new
    end
  end

  def show
    @team = Team.includes(
      team_monthly_forecasts: :monthly_forecast,
      members: :role, 
      team_fields: :field
    ).find_by(slug: params[:team_name])
    @recent_team_monthly_forecasts = @team.team_monthly_forecasts.joins(:monthly_forecast).order("monthly_forecasts.date DESC").first(4)
    @current_team_monthly_forecast = @team.current_forecast
    if @team.nil?
      redirect_to teams_path
    end
  end

  def edit
    @team = Team.find_by(slug: params[:team_name]) if @team.nil?
    if @team
      render :edit
    else
      redirect_to action: :index, team_name: params[:team_name]
    end
  end

  def update
    @team = Team.find_by(slug: params[:team_name]) if @team.nil?
    if @team&.update(team_params)
      redirect_to team_path(@team.slug)
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find_by(slug: params[:team_name]) if @team.nil?
    if @team&.destroy
      redirect_to action: :index
    else
      render :show
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
