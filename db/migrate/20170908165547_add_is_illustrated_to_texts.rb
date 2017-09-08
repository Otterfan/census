class AddIsIllustratedToTexts < ActiveRecord::Migration[5.1]
  def change
    add_column :texts, :is_illustrated, :boolean

    reversible do |direction|
      direction.up {add_is_illustrated}
    end
  end
end
