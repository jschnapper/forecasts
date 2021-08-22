# frozen_string_literal: true

# == Schema Information
#
# Table name: member_forecasts
#
#  id                  :bigint           not null, primary key
#  hours               :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  member_id           :bigint           not null
#  monthly_forecast_id :bigint           not null
#  team_id             :bigint           not null
#
# Indexes
#
#  index_member_forecasts_on_member_id                         (member_id)
#  index_member_forecasts_on_monthly_forecast_id               (monthly_forecast_id)
#  index_member_forecasts_on_monthly_forecast_member_and_team  (monthly_forecast_id,member_id,team_id) UNIQUE
#  index_member_forecasts_on_team_id                           (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (monthly_forecast_id => monthly_forecasts.id)
#  fk_rails_...  (team_id => teams.id)
#
class MemberForecast < ApplicationRecord
  # callbacks
  before_save :format_hours

  # associations
  belongs_to :member
  belongs_to :monthly_forecast
  belongs_to :team

  # validations
  validates :member, presence: true
  validates :monthly_forecast, presence: true
  validates :team, presence: true

  # ------ Helper methods ------ #
  def total_hours
    hours.values.reduce { |total, amount| total + amount.to_i }
  end

  private

  # ensure the jsonb hours are in the proper format
  # and are whole numbers
  def format_hours
    hours.each do |field, amount|
      hours[field] = amount.to_i
    end
  end
end
