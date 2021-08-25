# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id          :bigint           not null, primary key
#  code        :string
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_fields_on_code  (code) UNIQUE
#  index_fields_on_name  (name) UNIQUE
#
class Field < ApplicationRecord
  # callbacks
  before_validation :format_fields

  # associations
  has_many :team_fields, dependent: :destroy
  has_many :teams, through: :team_fields

  # validations
  # name is not case sensitive but code is
  validates :code, uniqueness: true, allow_nil: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  private

  # format fields before saving
  #   - strip whitespace
  #   - downcase
  def format_fields
    self.name = name.strip.downcase if name.present?
  end
end
