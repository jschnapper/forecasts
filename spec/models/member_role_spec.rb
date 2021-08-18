# == Schema Information
#
# Table name: member_roles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint
#  role_id    :bigint
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
require 'rails_helper'

RSpec.describe MemberRole, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
