# == Schema Information
#
# Table name: team_fields
#
#  id         :bigint           not null, primary key
#  end_after  :date
#  revoked_at :date
#  start_on   :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  field_id   :bigint           not null
#  team_id    :bigint           not null
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
require 'rails_helper'

RSpec.describe TeamField, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
