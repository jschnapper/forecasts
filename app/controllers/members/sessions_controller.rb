class Members::SessionsController < Devise::SessionsController
  before_action :find_user, only: :create
  # user cannot sign in if they dont have a role

  private

  def find_user
    member = Member.includes(:role).find_by(email: params[:member][:email])
    if member && member&.role.nil?
      set_flash_message! :alert, :not_permitted
      redirect_to action: :new
    end
  end
end