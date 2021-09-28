class RemindersController < ManagementController
  before_action -> { requires_at_least_role :manager }
  before_action :set_members, only: :create

  # send reminder

  def new
    respond_to do |format|
      format.js { render 'shared/modal', locals: { submit: 'Send', form_name: 'reminder-form' } }
    end
  end

  def create
    SendReminder.call(@teams, monthly_forecast)
    respond_to do |format|
      format.js { render inline: "location.reload()"}
    end
  end

  private

  def monthly_forecast
    @monthly_forecast ||= MonthlyForecast.last
  end

  def set_members
    if params[:team_name]
      @teams = Team.includes(:members).find_by(slug: params[:team_name])
    else
      @teams = Team.includes(:members).all
    end
  end
end