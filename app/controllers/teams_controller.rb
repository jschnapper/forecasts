# frozen_string_literal: true
class TeamsController < ManagementController
  # before_action -> { permit_roles :admin, :management }, except: [:index, :destroy]
  # before_action -> { permit_roles :admin }, only: [:index, :destroy]

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
    @team = Team.includes(:members).find_by(slug: params[:team_name])
    if @team.nil?
      redirect_to teams_path
    end
  end

  def edit
    @team = Team.find_by(slug: params[:team_name])
    if @team
      render :edit
    else
      redirect_to action: :index, team_name: params[:team_name]
    end
  end

  def update
    @team = Team.find_by(slug: params[:team_name])
    if @team&.update(team_params)
      redirect_to team_path(@team.slug)
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find_by(slug: params[:team_name])
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
