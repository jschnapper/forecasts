# == Schema Information
#
# Table name: monthly_forecasts
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  date          :date             not null
#  holiday_hours :integer          default(0), not null
#  total_hours   :integer          default(0), not null
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
