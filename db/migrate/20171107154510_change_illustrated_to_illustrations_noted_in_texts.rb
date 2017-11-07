class ChangeIllustratedToIllustrationsNotedInTexts < ActiveRecord::Migration[5.1]
  def change
    rename_column :texts, :is_illustrated, :illustrations_noted
  end
end
