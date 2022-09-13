class CreateVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :variables do |t|
      t.string :name
      t.string :label
      t.text :description
      t.string :variable_type
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
