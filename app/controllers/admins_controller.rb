class AdminsController < ManagementController
  before_action -> { requires_at_least_role :admin }

  def index
    render :index
  end
end