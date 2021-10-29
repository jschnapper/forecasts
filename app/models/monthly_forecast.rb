# frozen_string_literal: true

# == Schema Information
#
# Table name: monthly_forecasts
#
#  id            :bigint           not null, primary key
#  date          :date             not null
#  holiday_hours :integer          default(0), not null
#  message       :text
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
  before_create :build_team_monthly_forecasts

  # associations
  has_many :team_monthly_forecasts, dependent: :destroy

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

  # build monthly forecasts for each team
  def build_team_monthly_forecasts
    team_ids = Team.all.pluck(:id).map { |team_id| { team_id: team_id } }
    self.team_monthly_forecasts.new(team_ids)
  end
end
