# == Schema Information
#
# Table name: fields
#
#  id          :bigint           not null, primary key
#  code        :string
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_fields_on_code  (code) UNIQUE
#  index_fields_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Field, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
