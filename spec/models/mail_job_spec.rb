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
require 'rails_helper'

RSpec.describe MailJob, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
