class AddTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :type, :int, default: 0
  end
end
