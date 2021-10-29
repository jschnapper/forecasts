class MembershipsController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }

  # Remove member from team
  def update
    @member = Member.find_by(id: params[:member_id])
    @member.update(team_id: nil)
    redirect_to team_path(team_name: params[:team_name])
  end
end 