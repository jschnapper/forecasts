# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint
#  team_id    :bigint
#
# Indexes
#
#  index_memberships_on_member_id  (member_id)
#  index_memberships_on_team_id    (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (team_id => teams.id)
#
class Membership < ApplicationRecord
end
