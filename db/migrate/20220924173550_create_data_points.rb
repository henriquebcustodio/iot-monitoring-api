class CreateDataPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :data_points do |t|
      t.boolean :bool_value
      t.float :numeric_value
      t.text :text_value
      t.datetime :timestamp, null: false
      t.references :variable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
