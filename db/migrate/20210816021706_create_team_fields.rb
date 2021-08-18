class CreateTeamFields < ActiveRecord::Migration[6.1]
  def change
    create_table :team_fields do |t|
      t.references :team, foreign_key: true
      t.references :field, foreign_key: true
      t.timestamps
    end
  end
end
