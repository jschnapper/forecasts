class AdminsController < ManagementController
  before_action -> { requires_role :admin }

  def index
    render :index
  end
end