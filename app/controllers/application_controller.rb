class ApplicationController < ActionController::Base

  # change home path based on user
  def home_path
    current_member.present? ? after_sign_in_path_for(current_member) : root_path
  end
  
  # override after sign in path
  def after_sign_in_path_for(member) 
    case member.role.name
    when 'admin'
      # redirect to admin home
      admin_home_path
    when 'manager', 'representative'
      # redirect to team page
      team_path(member.team.slug)
    end
  end 
  
  helper_method :home_path
end
