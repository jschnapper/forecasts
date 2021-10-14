class ManagementController < ApplicationController
  # All admin and management actions must route through the 
  # management controller to ensure authentication
  before_action :authenticate_member!

  protected

  # some actions require users to have a certain role
  # role hierarchy: admin > manager > representative

  def is_admin?
    member_signed_in? && current_member.is_admin?
  end

  def is_manager?
    member_signed_in? && current_member.is_manager?
  end

  def is_representative?
    member_signed_in? && current_member.is_representative?
  end

  # permit certain role
  # @param role_name [Symbol] name of role (the least required permission)
  # @param team_name_slug [String] team name as slug to identify team
  #   if non-admin, then the member must be part of the requested team
  def requires_at_least_role(role_name, team_name_slug: nil)
    role_name = role_name.to_s.downcase
    if member_signed_in? && current_member&.role&.name && current_member.at_least_a?(role_name)
      # if team slug provided and user is not an admin
      # verify they belong to team
      if team_name_slug && !current_member.is_admin?
        @team = Team.find_by(slug: team_name_slug)
        if current_member.teams.first.id != @team.id  
          flash.now[:alert] = "You do not have the permission for this action"
          redirect_back fallback_location: root_path
        end
      end
    else
      flash.now[:alert] = "You do not have the permission for this action"
      redirect_back fallback_location: root_path
    end
  end
end