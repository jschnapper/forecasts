# frozen_string_literal: true

# == Schema Information
#
# Table name: team_fields
#
#  id         :bigint           not null, primary key
#  end_after  :date
#  revoked_at :date
#  start_on   :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  field_id   :bigint           not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_team_fields_on_field_id  (field_id)
#  index_team_fields_on_team_id   (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (field_id => fields.id)
#  fk_rails_...  (team_id => teams.id)
#

# A team field is considered "active" when inclusively between the START_ON and end_after dates
# This allows for a team field to be reused over certain time periods while still
# associating with previously submitted forecasts.
# A member_forecast should use the team_field to determine which fields
# are accepting entries, and then use the team_fields field_id as the record to match on.
# If a team field for a field is active, then you cannot add add a duplicate of that field 
# if it falls between the dates of the original start_on and end_after dates
class TeamField < ApplicationRecord
  has_paper_trail versions: {
    class_name: 'TeamFieldVersion'
  }
  belongs_to :field
  belongs_to :team

  validates :field, presence: true
  validates :team, presence: true
  validates :start_on, presence: true
  validate :valid_dates

  scope :active, -> (time = Time.zone.today) { where("start_on <= '#{time}' and (revoked_at is NULL or revoked_at >= '#{time.beginning_of_month + 1.month}') and (end_after is NULL or end_after >= '#{time}')")}
  scope :future, -> (time = Time.zone.today) { where("start_on > '#{time}' and revoked_at is NULL") }
  scope :inactive, -> (time = Time.zone.today) { where("(revoked_at is NOT NULL and <= '#{time.end_of_month}') or (end_after is not NULL and end_after <= '#{time}')") }

  def status
    if active
      :active
    elsif inactive
      :inactive
    end
  end

  def active?
    active
  end

  def inactive?
    inactive
  end

  def status_details
    if active? && end_after.present?
      "Ending after #{end_after.strftime("%B %Y")}"
    elsif inactive?
      "Starting on #{start_on.strftime("%B %Y")}"
    end
  end

  private

  def active
    start_on <= Time.zone.today && revoked_at.nil? && (end_after.nil? || end_after >= Time.zone.today)
  end

  def inactive
    start_on > Time.zone.today
  end

  # ensure the dates are valid
  def valid_dates
    if end_after.present? && end_after < start_on
      errors.add(:end_after, "The 'end after' date must be after the 'start on' date.")
    end
    # start on cannot be in a previous month
    if start_on.present? && start_on < Time.zone.today.beginning_of_month
      errors.add(:start_on, "Cannot add field to a previous forecast")
    end
  end
end
