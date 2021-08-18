# == Schema Information
#
# Table name: mail_histories
#
#  id          :bigint           not null, primary key
#  identifier  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  mail_job_id :bigint
#  process_id  :integer          default(0), not null
#  type_id     :integer          default(0), not null
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
end
