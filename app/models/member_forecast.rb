# == Schema Information
#
# Table name: member_forecasts
#
#  id                  :bigint           not null, primary key
#  hours               :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  member_id           :bigint
#  monthly_forecast_id :bigint
#  team_id             :bigint
#
# Indexes
#
#  index_member_forecasts_on_member_id                         (member_id)
#  index_member_forecasts_on_monthly_forecast_id               (monthly_forecast_id)
#  index_member_forecasts_on_monthly_forecast_member_and_team  (monthly_forecast_id,member_id,team_id) UNIQUE
#  index_member_forecasts_on_team_id                           (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (monthly_forecast_id => monthly_forecasts.id)
#  fk_rails_...  (team_id => teams.id)
#
class MemberForecast < ApplicationRecord
end
