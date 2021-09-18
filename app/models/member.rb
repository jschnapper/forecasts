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
         :timeoutable, :confirmable

  # callbacks
  # format all fields before saving
  before_validation :format_fields

  # associations
  has_many :member_roles, dependent: :destroy
  has_many :roles, through: :member_roles
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

  private

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
