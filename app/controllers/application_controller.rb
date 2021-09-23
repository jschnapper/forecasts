class ApplicationController < ActionController::Base

  # override after sign in path
  def after_sign_in_path_for(member) 
    case member.role.name
    when "admin"
      # redirect to admin home
      admin_home_path
    when "manager"
      # redirect to current forecast
      forecast_path(member.teams.first.slug)
    when "representative"
      # redirect to team details page
      team_path(member.teams.first.slug)
    end
  end 
end
