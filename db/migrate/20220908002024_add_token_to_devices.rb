class AddTokenToDevices < ActiveRecord::Migration[7.0]
  def change
    add_column :devices, :token, :string
  end
end
