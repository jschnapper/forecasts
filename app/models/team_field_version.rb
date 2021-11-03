# == Schema Information
#
# Table name: team_field_versions
#
#  id             :bigint           not null, primary key
#  event          :string           not null
#  item_type      :string
#  object         :text
#  whodunnit      :string
#  {:null=>false} :string
#  created_at     :datetime
#  item_id        :bigint           not null
#
# Indexes
#
#  index_team_field_versions_on_item_type_and_item_id  (item_type,item_id)
#
class TeamFieldVersion < PaperTrail::Version
  self.table_name = :team_field_versions
  self.sequence_name = :team_field_versions_id_seq
end
