# == Schema Information
#
# Table name: members
#
#  id          :bigint           not null, primary key
#  email       :string           not null
#  first_name  :string
#  last_name   :string
#  middle_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_members_on_email                                     (email) UNIQUE
#  index_members_on_last_name_and_middle_name_and_first_name  (last_name,middle_name,first_name) UNIQUE
#
class Member < ApplicationRecord
end
