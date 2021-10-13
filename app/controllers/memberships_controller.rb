class MembershipsController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }
  before_action -> { requires_at_least_role :admin }

  def destroy
    @membership = Membership.find_by(id: params[:membership_id])
    p @membership
    @membership.destroy
    redirect_back fallback_location: teams_path
  end
end 