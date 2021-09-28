# frozen_string_literal: true

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
class MonthlyForecast < ApplicationRecord
  # callback
  before_create :calculate_hours

  # associations
  has_many :holidays, dependent: :destroy
  has_many :member_forecast, dependent: :destroy

  scope :active, -> { where(active: true) }


  # validations
  validates :date, presence: true

  # friendly name for monthly forecast
  def friendly_name
    "#{friendly_date} Forecast"
  end

  # friendly date for monthly forecast
  def friendly_date
    "#{date&.strftime('%B %Y')}"
  end

  # month name
  def month_name
    date.strftime('%B')
  end

  def year
    date.year
  end

  # has holiday check
  def has_holidays?
    holiday_hours > 0
  end

  private

  def calculate_hours
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    self.total_hours = 0
    [*start_date..end_date].each do |day|
      if [*1..5].include?(day.wday)
        self.total_hours += 8
      end
    end

    self.holiday_hours = Holiday.where(date: start_date..end_date).count * 8
  end
end
