class ChangeRoleToString < ActiveRecord::Migration[5.1]
  def change
    remove_reference :text_citations, :role
  end
end
