class SetBilingualFlag < ActiveRecord::Migration[5.1]
  def change
    Text.where("original like ?", "%ilingual%").each do |text|
      text.is_bilingual = true
      text.save
    end
  end
end
