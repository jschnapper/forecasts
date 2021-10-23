class RemindersController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :monthly_forecast, only: :new
  before_action :set_members, only: :create

  # send reminder

  def new
    respond_to do |format|
      @team = Team.find_by(slug: params[:team_name]) if params[:team_name].present?
      format.js { render 'shared/modal', locals: { submit: 'Send', form_name: 'reminder-form' } }
    end
  end

  def create
    SendReminder.call(@teams, monthly_forecast, params[:message])
    respond_to do |format|
      format.js { render inline: "location.reload()"}
    end
  end

  private

  def monthly_forecast
    @monthly_forecast ||= set_monthly_forecast
  end

  def set_monthly_forecast
    if params[:monthly_forecast_id]
      MonthlyForecast.find_by(id: params[:monthly_forecast_id]) || (MonthlyForecast.find_by(date: Date.parse("#{Date.today.strftime('%Y/%B')}")) || MonthlyForecast.last)
    else
      MonthlyForecast.find_by(date: Date.parse("#{Date.today.strftime('%Y/%B')}")) || MonthlyForecast.last
    end
  end

  def set_members
    if params[:team_name]
      @teams = Team.includes(:members).find_by(slug: params[:team_name])
    else
      @teams = Team.includes(:members).all
    end
  end
end