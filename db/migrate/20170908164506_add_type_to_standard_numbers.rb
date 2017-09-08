class AddTypeToStandardNumbers < ActiveRecord::Migration[5.1]
  def change
    add_column :standard_numbers, :numtype, :string

    reversible do |direction|
      direction.up {add_types}
    end
  end

  def add_types
    StandardNumber.all.each do |number|
      number.numtype = 'ISBN'
      number.save
      end
  end

end
