# == Schema Information
#
# Table name: members
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  middle_name            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :bigint
#  team_id                :bigint
#
# Indexes
#
#  index_members_on_confirmation_token                        (confirmation_token) UNIQUE
#  index_members_on_email                                     (email) UNIQUE
#  index_members_on_last_name_and_middle_name_and_first_name  (last_name,middle_name,first_name) UNIQUE
#  index_members_on_reset_password_token                      (reset_password_token) UNIQUE
#  index_members_on_role_id                                   (role_id)
#  index_members_on_team_id                                   (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe Member, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
