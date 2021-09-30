# frozen_string_literal: true

# == Schema Information
#
# Table name: member_forecasts
#
#  id                  :bigint           not null, primary key
#  hours               :jsonb
#  notes               :text
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

  scope :get_member_forecasts, ->(teams, monthly_forecast) { find_by_sql(get_member_forecasts_sql(teams, monthly_forecast)) }

  def hours
    self[:hours]&.with_indifferent_access
  end

  # ------ Helper methods ------ #
  def total_hours
    # grab fields since fields could be different from what was submitted
    # TODO: why is rails complaining about team_id?
    # hours&.slice(*team&.fields&.map(&:name))&.values&.reduce { |total, amount| total.to_i + amount.to_i } || 0
    hours&.values&.reduce { |total, amount| total.to_i + amount.to_i } || 0
  end

  private

  # ensure the jsonb hours are in the proper format
  # and are whole numbers
  def format_hours
    hours.each do |field, amount|
      hours[field.downcase] = amount.to_i
    end
  end

  def self.get_member_forecasts_sql(teams, monthly_forecast)
    <<-SQL.squish
      select members.*, member_forecasts.hours, member_forecasts.notes
      from members
      inner join memberships
      on memberships.member_id = members.id
      and memberships.team_id in (#{[teams].flatten.map(&:id).join(",")})
      left join member_forecasts
      on member_forecasts.member_id = members.id
      and member_forecasts.monthly_forecast_id = #{monthly_forecast.id}
      order by members.first_name
    SQL
  end
end
