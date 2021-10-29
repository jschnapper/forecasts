# == Schema Information
#
# Table name: holidays
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_holidays_on_date  (date) UNIQUE
#
require 'rails_helper'

RSpec.describe Holiday, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
