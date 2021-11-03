# frozen_string_literal: true

# Add and remove field from a team
# only has create and destroy methods
class TeamFieldsController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }
  before_action :set_team
  before_action :set_fields, except: :destroy

  def new
    @team_field = TeamField.new
    @field = Field.find_by(id: params[:field_id])
    @team_monthly_forecast = team_monthly_forecast
    respond_to do |format|
      format.html { render :new }
      format.js { render :form_ajax }
    end  
  end

  def create
    begin
      ActiveRecord::Base.transaction do 
        if TeamField.future.where(team_id: @team.id, field_id: params.dig(:team_field, :field_ids)&.map(&:to_i)).size > 0
          existing_team_fields = TeamField.future.where(team_id: @team.id, field_id: params.dig(:team_field, :field_ids)&.map(&:to_i))
          # remove existing ids from field ids array
          params[:team_field][:field_ids] = (params.dig(:team_field, :field_ids)&.map(&:to_i) || []) - existing_team_fields.pluck(:field_id)
          existing_team_fields.each do |team_field|
            team_field.start_on = team_monthly_forecast.date
            team_field.save!
          end
        end
        team_fields = []
        params.dig(:team_field, :field_ids)&.each do |field_id|
          team_fields << { 
            team_id: params[:team_field][:team_id]&.to_i, 
            field_id: field_id&.to_i,
            start_on: team_monthly_forecast.date
          }
        end
        if team_fields.size > 0
          TeamField.create!(team_fields)
        end

        if team_monthly_forecast
          redirect_to forecast_path( 
            team_name: @team.slug, 
            year: team_monthly_forecast.date.year,
            month: team_monthly_forecast.month_name
          )
        else
          redirect_to team_path(team_name: @team_field.team.slug)
        end
      end
    rescue => e
      render :new
    end
  end

  def edit
    @team_field = TeamField.new
    @team_monthly_forecast = team_monthly_forecast
    @view = 'edit'
    respond_to do |format|
      format.js { render 'shared/modal' }
    end
  end

  def destroy
    @team_field = TeamField.find_by(id: params[:id])
    @team_field.update(revoked_at: team_monthly_forecast.date)
    redirect_back fallback_location: teams_path
  end

  private

  def set_team
    @team = team
  end

  def team
    @team ||= Team.includes(:team_fields, :fields).find_by(slug: params[:team_name])
  end

  def set_team_monthly_forecast
    team_monthly_forecast
  end

  def team_monthly_forecast
    @team_monthly_forecast || TeamMonthlyForecast.find_by(id: params[:team_monthly_forecast_id]&.to_i)
  end

  def set_fields
    # only select fields that team doesnt already have
    @fields = Field.where.not(id: TeamField.active(team_monthly_forecast&.date).where(team_id: team.id).pluck(:field_id))
  end

  def team_field_params
    params.require(:team_field).permit(:team_id, :field_ids)
  end

end