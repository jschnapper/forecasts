class RemindersController < ManagementController
  before_action -> { requires_at_least_role :manager }

  # send reminder

  def new
  end

  def create
  end

  private
end