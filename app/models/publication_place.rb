class PublicationPlace < ApplicationRecord
  belongs_to :text
  belongs_to :place

  after_save {
    puts "PublicationPlace record '#{self.id}' was updated. Will now update related Text record: [#{self.text.id}]"
  }
end
