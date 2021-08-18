class CreateMailJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_jobs do |t|
      t.string :name
      t.text :description
      t.references :team, foreign_key: true
      t.text :email_body
      t.string :schedule
      t.timestamps
    end

    add_index :mail_jobs, [:team_id, :name], unique: true
  end
end
