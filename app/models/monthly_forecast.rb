# frozen_string_literal: true

# == Schema Information
#
# Table name: monthly_forecasts
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  date          :date             not null
#  holiday_hours :integer          default(0), not null
#  work_hours    :integer          default(0), not null
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

  # friendly name for monthly forecast
  def friendly_name
    "#{date&.strftime('%B %Y')} Forecast"
  end

  def total_hours
    work_hours + holiday_hours
  end
end
