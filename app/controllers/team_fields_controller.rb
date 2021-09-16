# frozen_string_literal: true

# Add and remove field from a team
# only has create and destroy methods
class TeamFieldsController < ApplicationController
  before_action :set_team, :set_fields, only: :new

  def new
    @team_field = TeamField.new
    render :new
  end

  def create
    @team_field = TeamField.new(team_field_params)
    if @team_field.save
      redirect_to @team_field.team
    else
      render :new
    end
  end

  def destroy
    @team_field = TeamField.find_by(id: params[:id])
    @team_field.destroy
    redirect_back fallback_location: teams_path
  end

  private

  def set_team
    @team = team
  end

  def team
    @team ||= Team.includes(:fields).find_by(slug: params[:team_name])
  end

  def set_fields
    # only select fields that team doesnt already have
    @fields = Field.where.not(id: team.fields.pluck(:id))
  end

  def team_field_params
    params.require(:team_field).permit(:team_id, :field_id)
  end
end