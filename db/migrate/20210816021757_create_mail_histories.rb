class CreateMailHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_histories do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.references :mail_job, foreign_key: true, null: false
      t.integer :type, default: 0, null: false
      t.integer :process, default: 0, null: false
      t.timestamps
    end
  end
end
