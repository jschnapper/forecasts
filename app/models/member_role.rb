# frozen_string_literal: true

# == Schema Information
#
# Table name: member_roles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint           not null
#  role_id    :bigint           not null
#
# Indexes
#
#  index_member_roles_on_member_id  (member_id)
#  index_member_roles_on_role_id    (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (role_id => roles.id)
#
class MemberRole < ApplicationRecord
  belongs_to :member
  belongs_to :role

  validates :member, presence: true
  validates :role, presence: true
end
