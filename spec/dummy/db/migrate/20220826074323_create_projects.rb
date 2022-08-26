class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.references :account, foreign_key: true, null: false
      t.string :name, limit: 120, null: false
      t.timestamps
    end

    add_index :projects, [:account_id, :name], unique: true
  end
end
