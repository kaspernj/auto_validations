class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, index: {unique: true}, null: false
      t.string :vat_number, limit: 20
      t.string :callsign, index: {unique: true}
      t.timestamps
    end
  end
end
