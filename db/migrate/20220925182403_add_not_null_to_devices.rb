class AddNotNullToDevices < ActiveRecord::Migration[7.0]
  def change
    change_column_null :devices, :name, false
  end
end
