# frozen_string_literal: true

# == Schema Information
#
# Table name: mail_jobs
#
#  id          :bigint           not null, primary key
#  description :text
#  email_body  :text
#  name        :string           not null
#  schedule    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint           not null
#
# Indexes
#
#  index_mail_jobs_on_team_id           (team_id)
#  index_mail_jobs_on_team_id_and_name  (team_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class MailJob < ApplicationRecord
  # associations
  belongs_to :team
  has_many :mail_histories, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: { scope: :team, case_sensitive: false }
  validates :team, presence: true
end
