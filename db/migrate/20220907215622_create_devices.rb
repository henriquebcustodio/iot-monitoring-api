class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :label
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
