class StandardNumber < ApplicationRecord
  belongs_to :text

  after_save {
    puts "StandardNumber record '#{self.id}' was updated. Will now touch related Text record: [#{self.text.id}]"
  }
end
