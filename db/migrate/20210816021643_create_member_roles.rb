class CreateMemberRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :member_roles do |t|
      t.references :role, foreign_key: true
      t.references :member, foreign_key: true
      t.timestamps
    end
  end
end
