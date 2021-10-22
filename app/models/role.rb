# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#
class Role < ApplicationRecord
  # callbacks
  before_validation :format_fields

  # associations
  has_many :members, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  private

  # format all fields before saving
  #   - strip whitespace
  #   - downcase
  def format_fields
    self.name = name.strip.downcase if name.present?
  end
end
