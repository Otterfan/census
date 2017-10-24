class AddDisplayToStatuses < ActiveRecord::Migration[5.1]
  def change
    add_column :statuses, :display, :string
  end
end
