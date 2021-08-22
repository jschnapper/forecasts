# == Schema Information
#
# Table name: monthly_forecasts
#
#  id            :bigint           not null, primary key
#  date          :date             not null
#  holiday_hours :integer
#  work_hours    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_monthly_forecasts_on_date  (date) UNIQUE
#
require 'rails_helper'

RSpec.describe MonthlyForecast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
