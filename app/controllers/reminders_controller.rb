class RemindersController < ManagementController
  before_action -> { requires_at_least_role :manager }

  # send reminder

  def new
    respond_to do |format|
      format.js { render 'shared/modal', locals: { submit: 'Send', form_name: 'reminder-form' } }
    end
  end

  def create
    respond_to do |format|
      format.js { render "document.getElementById('modal').classList.add('hidden')"}
    end
  end

  private
end