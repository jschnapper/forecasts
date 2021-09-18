class ManagementController < ApplicationController
  # All admin and management actions must route through the 
  # management controller to ensure authentication
  # before_action :authenticate_member!

  protected

  # some actions require users to have a certain role
  # role hierarchy: admin > manager > representative

  def is_admin?
    member_signed_in? && member.is_admin?
  end

  def is_manager?
    member_signed_in? && member.is_manager?
  end

  def is_representative?
    member_signed_in? && member.is_representative?
  end

  # permit certain roles
  # the member only needs one of roles provided
  # @param role_names [Symbol] names of roles
  def permit_roles(*role_names)
    parsed_names = role_names&.map { |name| name.to_s.downcase } || []
    if member_signed_in? && 
      ((member.role_names - parsed_names).size < member.role_names.size)
      # continue
    else
      redirect_to :back
    end
  end
end