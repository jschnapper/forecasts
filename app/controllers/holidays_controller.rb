class HolidaysController < ApplicationController
  
  def index
    # Get the most recent 20 holidays
    @holidays = Holiday.order(date: :desc).first(20)
    render :index
  end

  def new
    @holiday = Holiday.new
  end
  
  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      redirect_to @holiday
    else
      render :new
    end
  end

  def show
    @holiday = Holiday.find_by(id: params[:id])
    if @holiday.nil?
      redirect_to action: :index
    end
  end

  def edit
    @holiday = Holiday.find_by(id: params[:id])
    if @holiday
      render :edit
    else
      redirect_to action: :index
    end
  end

  def update
    @holiday = Holiday.find_by(id: params[:id])
    if @holiday&.update(holiday_params)
      redirect_to(@holiday)
    else
      render :edit
    end
  end

  def destroy
    @holiday = Holiday.find_by(id: params[:id])
    if @holiday&.destroy
      redirect_to action: :index
    else
      render :show
    end
  end

  private

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end
end
