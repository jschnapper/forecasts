# frozen_string_literal: true

# == Schema Information
#
# Table name: member_forecasts
#
#  id                       :bigint           not null, primary key
#  hours                    :jsonb
#  notes                    :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  member_id                :bigint           not null
#  team_monthly_forecast_id :bigint           not null
#
# Indexes
#
#  index_member_forecasts_on_member_id                     (member_id)
#  index_member_forecasts_on_team_monthly_forecast_id      (team_monthly_forecast_id)
#  index_member_forecasts_on_team_monthly_forecast_member  (team_monthly_forecast_id,member_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (team_monthly_forecast_id => team_monthly_forecasts.id)
#
class MemberForecast < ApplicationRecord
  has_paper_trail versions: {
    class_name: 'MemberForecastVersion'
  }

  # callbacks
  before_save :format_hours

  # associations
  belongs_to :member
  belongs_to :team_monthly_forecast

  # validations
  validates :member, presence: true, uniqueness: { scope: :team_monthly_forecast }
  validates :team_monthly_forecast, presence: true
  validate :has_notes

  scope :get_member_forecasts, ->(teams, monthly_forecast) { find_by_sql(get_member_forecasts_sql(teams, monthly_forecast)) }
  scope :member_forecast, -> (member_id) { }

  def hours
    self[:hours]&.with_indifferent_access
  end

  # ------ Helper methods ------ #
  def total_hours
    # grab fields since fields could be different from what was submitted
    # TODO: why is rails complaining about team_id?
    # TODO: should base this on active team fields for the current forecast in case fields are removed after submission
    # hours&.slice(*team&.fields&.map(&:name))&.values&.reduce { |total, amount| total.to_i + amount.to_i } || 0
    sum = 0
    if team_monthly_forecast_id && hours.present?
      team_monthly_forecast&.ordered_team_fields&.each do |team_field|
        sum += (hours[team_field.field_id.to_s]&.to_i || 0)
      end
    end
    sum
  end

  private

  # ensure the jsonb hours are in the proper format
  # and are whole numbers
  def format_hours
    hours.each do |field, amount|
      hours[field] = amount.to_i
    end
  end

  # ensure that if they are passing "other"
  # that they have notes to accompany it
  def has_notes
    if hours[Field.find_by(name: "Other").id.to_s].present? && notes.empty?
      errors.add(:notes, "If including 'other' hours, please list what the hours are for in the notes")
    end
  end

  # ensure that if they are passing "other"
  # that they have notes to accompany it
  def has_notes
    if hours["Other"].present? && notes.empty?
      errors.add(:notes, "If including 'other' hours, please list what the hours are for in the notes")
    end
  end

  def self.get_member_forecasts_sql(teams, monthly_forecast)
    <<-SQL.squish
      select members.*, members.id as member_id, team_monthly_forecasts.id as team_monthly_forecast_id, member_forecasts.hours, member_forecasts.notes
      from members
      left join team_monthly_forecasts
      on team_monthly_forecasts.monthly_forecast_id = #{monthly_forecast.id}
      left join member_forecasts
      on member_forecasts.member_id = members.id
      and member_forecasts.team_monthly_forecast_id = team_monthly_forecasts.id
      where team_monthly_forecasts.team_id = members.team_id
      and members.team_id in (#{[teams].flatten.map(&:id).join(",")})
      order by members.first_name
    SQL
  end
end
