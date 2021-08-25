# frozen_string_literal: true

# == Schema Information
#
# Table name: mail_histories
#
#  id          :bigint           not null, primary key
#  identifier  :string           not null
#  process     :integer          default("not_started"), not null
#  type        :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  mail_job_id :bigint           not null
#
# Indexes
#
#  index_mail_histories_on_identifier   (identifier) UNIQUE
#  index_mail_histories_on_mail_job_id  (mail_job_id)
#
# Foreign Keys
#
#  fk_rails_...  (mail_job_id => mail_jobs.id)
#
class MailHistory < ApplicationRecord
  # associations
  belongs_to :mail_job

  # validations
  validates :identifier, presence: true, uniqueness: true
  validates :mail_job, presence: true

  # enums
  enum process: {
    not_started: 0,
    in_progress: 1,
    error: 2,
    finished: 3
  }
end
