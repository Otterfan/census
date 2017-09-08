class SetIsIllustratedFlag < ActiveRecord::Migration[5.1]
  def change
    Text.where("original like ?", "%llustra%").each do |text|
      text.is_illustrated = true
      text.save!
    end

    Text.where(is_illustrated: [false, nil]).each do |text|
      text.is_illustrated = false
      text.save!
    end
  end
end
