# frozen_string_literal: true

# frozen_string_literal: true

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
class Holiday < ApplicationRecord
  # callbacks
  before_validation :format_fields
  after_destroy :remove_hours
  after_commit :update_monthly_forecast

  # association
  belongs_to :monthly_forecast, optional: true

  # validations
  validates :date, presence: true

  private

  # format fields before saving
  #   - strip whitespace
  #   - downcase
  def format_fields
    self.name = name.strip.downcase if name.present?
  end

  # updates existing monthly forecasts
  def update_monthly_forecast
    forecast = MonthlyForecast.find_by(date: date.beginning_of_month)
    if forecast
      # add 8 holiday hours
      forecast.holiday_hours += 8
      forecast.save
    end
  end

  def remove_hours
    forecast = MonthlyForecasts.find_by(date: date.beginning_of_month)
    if forecast
      # remove 8 holiday hours
      forecast.holiday_hours -= 8
      forecast.save
    end
  end
end
