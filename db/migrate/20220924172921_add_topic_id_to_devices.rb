class AddTopicIdToDevices < ActiveRecord::Migration[7.0]
  def change
    add_column :devices, :topic_id, :string
  end
end
