class AddTokenToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :token, :string, default: -> { "UUID()" }
  end
end
