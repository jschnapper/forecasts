# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  middle_name            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_members_on_confirmation_token                        (confirmation_token) UNIQUE
#  index_members_on_email                                     (email) UNIQUE
#  index_members_on_last_name_and_middle_name_and_first_name  (last_name,middle_name,first_name) UNIQUE
#  index_members_on_reset_password_token                      (reset_password_token) UNIQUE
#
class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable
         # :confirmable

  # callbacks
  # format all fields before saving
  before_validation :format_fields

  # associations
  has_one :member_role, dependent: :destroy
  has_one :role, through: :member_role
  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :member_forecasts, dependent: :destroy

  # validations
  validates :email, presence: true, uniqueness: {
    case_sensitive: false
  }
  validates :first_name, uniqueness: {
    scope: %i[middle_name last_name],
    case_sensitive: false
  }

  # display full name
  def full_name
    # remove repeat whitespace and display full name
    "#{first_name} #{middle_name} #{last_name}".squeeze(' ')
  end

    # member roles
  # role hierarchy: admin > manager > representative
  def at_least_a_manager?
    case role&.name&.downcase
    when 'admin', 'manager'
      true
    else
      false
    end
  end

  def at_least_a_representative?
    case role&.name&.downcase
    when 'admin', 'manager', 'representative'
      true
    else
      false
    end
  end

  # verifies member is at least the provided team name
  def at_least_a?(role_name)
    at_least_role_name = role_name.to_s.downcase
    case at_least_role_name
    when 'admin'
      is_admin?
    when 'manager'
      at_least_a_manager?
    when 'representative'
      at_least_a_representative?
    end
  end

  def is_admin?
    role&.name&.downcase == 'admin'
  end

  def is_manager?
    role&.name&.downcase == 'manager'
  end

  def is_representative?
    role&.name&.downcase == 'representative'
  end

  private

  # password isnt required for new records
  def password_required?
    return false if new_record?
    super
  end

  # format all fields before saving
  #   - strip extra whitespace
  #   - downcase
  def format_fields
    # downcase email, first name, middle name, and last name
    %i[email first_name middle_name last_name].each do |attribute|
      send("#{attribute}=", send(attribute).strip.downcase) if send(attribute).present?
    end
  end
end
