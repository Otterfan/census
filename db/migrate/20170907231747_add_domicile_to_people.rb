class AddDomicileToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :domicile, :string
  end
end
