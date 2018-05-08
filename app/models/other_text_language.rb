class OtherTextLanguage < ApplicationRecord
  belongs_to :text
  belongs_to :language

  accepts_nested_attributes_for :language, :reject_if => :all_blank

  after_save {
    puts "OtherTextLanguage record '#{self.id}' was updated. Will now update related Text record: [#{self.text.id}]"
  }
end
