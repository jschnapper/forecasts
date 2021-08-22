class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.references :team, foreign_key: true, null: false
      t.references :member, foreign_key: true, null: false
      t.timestamps
    end
  end
end
