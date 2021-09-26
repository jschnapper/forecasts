# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                     :bigint           not null, primary key
#  code                   :string
#  default                :boolean          default(FALSE), not null
#  description            :text
#  name                   :string           not null
#  only_admins_can_delete :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_fields_on_code  (code) UNIQUE
#  index_fields_on_name  (name) UNIQUE
#
class Field < ApplicationRecord
  # callbacks
  before_validation :format_fields
  before_destroy :verify_deletion

  # associations
  has_many :team_fields, dependent: :destroy
  has_many :teams, through: :team_fields

  # validations
  # name is not case sensitive but code is
  validates :code, uniqueness: true, allow_nil: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # additional attribtues
  # set to true for admin approval to delete field
  attr_accessor :admin_approved_deletion

  private

  # when a deletion can only be made by an admin
  # and this attribute is set to true
  # then a field can be deleted
  # if a filed does not require admin approval to be deleted
  # it can be deleted
  def verify_deletion
    if only_admins_can_delete && !admin_approved_deletion
      errors.add(:base, "Only admins can delete this field")
    end
  end

  # format fields before saving
  #   - strip whitespace
  #   - downcase
  def format_fields
    self.name = name.strip.downcase if name.present?
  end
end
