# == Schema Information
#
# Table name: member_forecasts
#
#  id                       :bigint           not null, primary key
#  hours                    :jsonb
#  notes                    :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  member_id                :bigint           not null
#  team_monthly_forecast_id :bigint           not null
#
# Indexes
#
#  index_member_forecasts_on_member_id                     (member_id)
#  index_member_forecasts_on_team_monthly_forecast_id      (team_monthly_forecast_id)
#  index_member_forecasts_on_team_monthly_forecast_member  (team_monthly_forecast_id,member_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (team_monthly_forecast_id => team_monthly_forecasts.id)
#
require 'rails_helper'

RSpec.describe MemberForecast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
