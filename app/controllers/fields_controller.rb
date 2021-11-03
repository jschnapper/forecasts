class FieldsController < ManagementController
  before_action -> { requires_at_least_role :representative }
  before_action :set_team_monthly_forecast

  def index
    @fields = Field.all
  end

  def new
    @field = Field.new
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      # if default is selected, it will be added to each foreact automatically
      if @team_monthly_forecast.present? && params[:default] == "0"
        TeamField.create(
          team_id: @team_monthly_forecast.team_id, 
          field_id: @field.id,
          start_on: @team_monthly_forecast.date
        )
      end
      if @team_monthly_forecast
        redirect_to forecast_path( 
          team_name: @team_monthly_forecast.team.slug, 
          year: @team_monthly_forecast.date.year,
          month: @team_monthly_forecast.month_name
        )
      else
        redirect_to @field
      end
    else
      render :new
    end
  end

  def show
    @field = Field.includes(team_fields: :team).find_by(id: params[:id])
    if @field.nil?
      redirect_to action: :index
    end
  end

  def edit
    @field = Field.find_by(id: params[:id])
    if @field
      render :edit
    else
      redirect_to action: :index
    end
  end

  def update
    @field = Field.find_by(id: params[:id])
    if @field&.update(field_params)
      redirect_to(@field)
    else
      render :edit
    end
  end

  def destroy
    @field = Field.find_by(id: params[:id])
    if @field&.destroy
      redirect_to action: :index
    else
      render :show
    end
  end

  private

  def set_team_monthly_forecast
    @team_monthly_forecast = TeamMonthlyForecast.includes(:team).find_by(id: params[:team_monthly_forecast_id])
  end

  def field_params
    params.require(:field).permit(:name, :code, :description, :default)
  end
end
