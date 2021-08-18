# == Schema Information
#
# Table name: team_fields
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  field_id   :bigint
#  team_id    :bigint
#
# Indexes
#
#  index_team_fields_on_field_id  (field_id)
#  index_team_fields_on_team_id   (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (field_id => fields.id)
#  fk_rails_...  (team_id => teams.id)
#
class TeamField < ApplicationRecord
end
