# frozen_string_literal: true

# Add and remove field from a team
# only has create and destroy methods
class TeamFieldsController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }
  before_action :set_team, :set_fields, only: [:new, :create]
  before_action :set_date, only: [:create]

  def new
    @team_field = TeamField.new
    @field = Field.find_by(id: params[:field_id])
    respond_to do |format|
      format.html { render :new }
      format.js { render :form_ajax }
    end  
  end

  def create
    begin
      ActiveRecord::Base.transaction do 
        if params[:team_field][:field_id]&.empty?
          @field = Field.new(field_params)
          @field.save!
          params[:team_field][:field_id] = @field.id
        end
        @team_field = TeamField.new(team_field_params)
        @team_field.save!
        redirect_to team_path(team_name: @team_field.team.slug)
      end
    rescue => e
      render :new
    end
  end

  def destroy
    @team_field = TeamField.find_by(id: params[:id])
    @team_field.update(revoked_at: DateTime.now)
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
    @fields = Field.where.not(id: team.active_fields.pluck(:id))
  end

  def field_params
    params.require(:team_field).permit(:name, :code, :description)
  end

  def team_field_params
    params.require(:team_field).permit(:team_id, :field_id, :start_on, :end_after)
  end

  def set_date
    if params.dig(:team_field, :"start_on(1i)")
      year = params.dig(:team_field, :"start_on(1i)")
      month = params.dig(:team_field, :"start_on(2i)")
      params[:team_field][:start_on] = "#{year}-#{month}-01"
      params[:team_field].extract!(:"start_on(1i)", :"start_on(2i)", :"start_on(3i)")
    end
    if params.dig(:team_field, :"end_after(1i)")
      year = params.dig(:team_field, :"end_after(1i)")
      month = params.dig(:team_field, :"end_after(2i)")
      params[:team_field][:end_after] = "#{year}-#{month}-01"
      params[:team_field].extract!(:"end_after(1i)", :"end_after(2i)", :"end_after(3i)")
    end
  end
end