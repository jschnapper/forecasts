class MonthlyForecastsController < ManagementController
  before_action -> { requires_at_least_role :admin }
  before_action :set_date, only: [:create, :update]

  def index
    @monthly_forecasts = MonthlyForecast.order(date: :desc).first(12)
    render :index
  end


  def new
    @monthly_forecast = MonthlyForecast.new
  end
  
  def create
    @monthly_forecast = MonthlyForecast.new(monthly_forecast_params)
    if @monthly_forecast.save
      redirect_to @monthly_forecast
    else
      render :new
    end
  end

  def show
    @monthly_forecast = MonthlyForecast.find_by(id: params[:id])
    if @monthly_forecast.nil?
      redirect_to action: :index
    end
  end

  def edit
    @monthly_forecast = MonthlyForecast.find_by(id: params[:id])
    if @monthly_forecast
      render :edit
    else
      redirect_to action: :index
    end
  end

  def update
    @monthly_forecast = MonthlyForecast.find_by(id: params[:id])
    if @monthly_forecast&.update(monthly_forecast_params)
      redirect_to(@monthly_forecast)
    else
      render :edit
    end
  end

  def destroy
    @monthly_forecast = MonthlyForecast.find_by(id: params[:id])
    if @monthly_forecast&.destroy
      redirect_to action: :index
    else
      render :show
    end
  end

  private

  def monthly_forecast_params
    params.require(:monthly_forecast).permit(:date, :active, :total_hours)
  end

  def set_date
    if params.dig(:monthly_forecast, :"name(1i)")
      year = params.dig(:monthly_forecast, :"name(1i)")
      month = params.dig(:monthly_forecast, :"name(2i)")
      params[:monthly_forecast][:date] = "#{year}-#{month}-01"
      params[:monthly_forecast].extract!(:"name(1i)", :"name(2i)", :"name(3i)")
    end
  end

end