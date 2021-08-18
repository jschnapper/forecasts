# == Schema Information
#
# Table name: holidays
#
#  id                  :bigint           not null, primary key
#  date                :date
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  monthly_forecast_id :bigint
#
# Indexes
#
#  index_holidays_on_monthly_forecast_id  (monthly_forecast_id)
#
# Foreign Keys
#
#  fk_rails_...  (monthly_forecast_id => monthly_forecasts.id)
#
class Holiday < ApplicationRecord
end
