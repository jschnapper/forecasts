class CreateTeamFields < ActiveRecord::Migration[6.1]
  def change
    create_table :team_fields do |t|
      t.references :team, foreign_key: true, null: false
      t.references :field, foreign_key: true, null: false
      t.timestamps
    end
  end
end
