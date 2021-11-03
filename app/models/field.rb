# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id          :bigint           not null, primary key
#  code        :string
#  default     :boolean          default(FALSE), not null
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
  # fields that we probably want to restrict from people deleting
  SPECIAL_FIELDS = [
    'holiday',
    'pto',
    'other'
  ].freeze

  # callbacks
  before_validation :format_fields
  after_commit :add_to_teams

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
  #   - set empty code to null
  def format_fields
    self.name = name.strip if name.present?
    self.code = nil if !code.present?
  end

  def add_to_teams
    if default
      # TODO: fix this. It will not work if setting default fields for a future month
      team_fields = Team.all.select(:id).map { |team| { team_id: team.id, field_id: id, start_on: Time.zone.today.beginning_of_month}}
      TeamField.create(team_fields)
    end
  end
end
