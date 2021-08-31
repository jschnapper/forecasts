# frozen_string_literal: true
class TeamsController < ApplicationController

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
    @team = Team.includes(:members).find_by(id: params[:id])
    if @team.nil?
      redirect_to action: :index
    end
  end

  def edit
    @team = Team.find_by(id: params[:id])
    if @team
      render :edit
    else
      redirect_to action: :index
    end
  end

  def update
    @team = Team.find_by(id: params[:id])
    if @team&.update(team_params)
      redirect_to(@team)
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find_by(id: params[:id])
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
