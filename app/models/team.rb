# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id                  :bigint           not null, primary key
#  allow_custom_fields :boolean          default(FALSE), not null
#  description         :text
#  name                :string           not null
#  slug                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_teams_on_name  (name) UNIQUE
#  index_teams_on_slug  (slug) UNIQUE
#
class Team < ApplicationRecord
  # callbacks
  # format all fields before saving
  before_validation :format_fields
  before_validation :set_slug # slug used for friendly url searching
  before_create :add_default_fields

  # associations
  has_many :team_fields, dependent: :destroy, autosave: true
  has_many :team_monthly_forecasts, dependent: :destroy
  has_many :fields, through: :team_fields
  has_many :members, dependent: :destroy
  has_many :mail_jobs, dependent: :destroy
  has_many :member_forecasts, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }


  # -------- helpers -------- #

  # Sort all fields by name
  def alpha_sort_fields
    fields.order("lower(name)") 
  end

  def holiday_field
    fields.detect { |field| field.name.downcase == 'holiday' }
  end

  def active_fields
    team_fields.active.join(:field).order("lower(fields.name)")
  end

  def inactive_fields
    team_fields.inactive.join(:field).order("lower(fields.name)")
  end
  # order fields
  #   - alphabetize
  #   - holiday
  #   - pto
  #   - other
  def ordered_fields
    @ordered_fields ||= order_fields
  end

  # order team fields association
  #   - alphabetize
  #   - holiday
  #   - pto
  #   - other
  def ordered_team_fields
    @ordered_team_fields || order_team_fields
  end

  # Get current forecast for team
  def current_forecast
    team_monthly_forecasts.joins(:monthly_forecast).find_by(monthly_forecasts: { date: Time.zone.today.beginning_of_month}) || team_monthly_forecasts.last
  end

  private

  def format_fields
    # strip and downcase attribute
    self.name = name.strip.downcase if name.present?
  end

  # use the name to set the slug
  def set_slug
    self.slug = name.strip.downcase.tr(' ', '-')
  end

  # order fields
  #   - alphabetize
  #   - holiday
  #   - pto
  #   - other
  def order_fields
    special_fields = {
      holiday: nil,
      pto: nil,
      other: nil
    }
    sorted_fields = []
    fields.order("lower(fields.name)").each do |field|
      if !special_fields.keys.include?(field.name.downcase.to_sym)
        sorted_fields << field
      else
        special_fields[field.name.downcase.to_sym] = field
      end
    end
    sorted_fields << special_fields[:holiday] if special_fields[:holiday]
    sorted_fields << special_fields[:pto] if special_fields[:pto]
    sorted_fields << special_fields[:other] if special_fields[:other]
    return sorted_fields
  end

  def order_team_fields
    special_fields = {
      holiday: nil,
      pto: nil,
      other: nil
    }
    sorted_team_fields = []
    active_fields.each do |team_field|
      if !special_fields.keys.include?(team_field.field.name.downcase.to_sym)
        sorted_team_fields.each do |s_field|
          if s_field.field.name.downcase < team_field.field.name.downcase
            break
          end
        end
        sorted_team_fields << team_field
      else
        special_fields[team_field.field.name.downcase.to_sym] = team_field
      end
    end
    sorted_team_fields << special_fields[:holiday] if special_fields[:holiday]
    sorted_team_fields << special_fields[:pto] if special_fields[:pto]
    sorted_team_fields << special_fields[:other] if special_fields[:other]
    return sorted_team_fields
  end

  # Create the default fields that are required for each team
  # - pto
  # - holiday
  # - other
  def add_default_fields
    default_fields = Field.where(default: true).pluck(:id).map { |field_id| {field_id: field_id, start_on: Time.zone.today.beginning_of_month} }
    team_fields.build(default_fields)
  end
end
