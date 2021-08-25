# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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

  # associations
  has_many :team_fields, dependent: :destroy
  has_many :fields, through: :team_fields
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships
  has_many :mail_jobs, dependent: :destroy
  has_many :member_forecasts, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  private

  def format_fields
    # strip and downcase attribute
    self.name = name.strip.downcase if name.present?
  end

  # use the name to set the slug
  def set_slug
    self.slug = name.strip.downcase.tr(' ', '-')
  end
end
