class CreateMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :memberships do |t|
      t.references :team, foreign_key: true
      t.references :member, foreign_key: true
      t.timestamps
    end
  end
end
