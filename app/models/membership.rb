# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint           not null
#  team_id    :bigint           not null
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
  # association
  belongs_to :member
  belongs_to :team

  validates :member, presence: true
  validates :team, presence: true
end
