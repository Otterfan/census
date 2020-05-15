class AddIsCollectedVolumeToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :is_collected_volume, :boolean
  end
end
