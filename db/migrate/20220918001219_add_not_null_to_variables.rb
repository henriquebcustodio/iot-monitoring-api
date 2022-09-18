class AddNotNullToVariables < ActiveRecord::Migration[7.0]
  def change
    change_column_null :variables, :name, false
    change_column_null :variables, :label, false
    change_column_null :variables, :variable_type, false
    change_column_null :variables, :description, false
  end
end
