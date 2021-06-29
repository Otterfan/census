class AddSeePersonToPeople < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :see_person, foreign_key: {to_table: :people}
  end
end
