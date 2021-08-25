# == Schema Information
#
# Table name: teams
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_teams_on_name  (name) UNIQUE
#  index_teams_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Team, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
