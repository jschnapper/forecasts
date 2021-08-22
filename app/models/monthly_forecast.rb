# frozen_string_literal: true

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
class MonthlyForecast < ApplicationRecord
  # associations
  has_many :holidays, dependent: :destroy
  has_many :member_forecast, dependent: :destroy

  # validations
  validates :date, presence: true
end
