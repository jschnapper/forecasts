class MembershipsController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }

  def destroy
    @membership = Membership.find_by(id: params[:membership_id])
    @membership.destroy
    redirect_to team_path(team_name: params[:team_name])
  end
end 