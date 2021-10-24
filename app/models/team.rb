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
  has_many :fields, through: :team_fields
  has_many :members, dependent: :destroy
  has_many :mail_jobs, dependent: :destroy
  has_many :member_forecasts, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }


  # -------- helpers -------- #
  def ordered_fields
    fields.order("lower(name)") 
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

  # Create the default fields that are required for each team
  # - pto
  # - holiday
  # - other
  def add_default_fields
    default_fields = Field.where(default: true).pluck(:id).map { |field_id| {field_id: field_id} }
    team_fields.build(default_fields)
  end
end
