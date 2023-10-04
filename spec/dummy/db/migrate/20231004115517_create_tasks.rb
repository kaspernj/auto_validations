class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :project, foreign_key: true, null: false
      t.string :name, index: {unique: true}, null: false
      t.timestamps
    end
  end
end
