class RemoveLabelFromDevices < ActiveRecord::Migration[7.0]
  def change
    remove_column :devices, :label
  end
end
