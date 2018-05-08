class CrossReference < ApplicationRecord
  belongs_to :text

  after_commit {
    puts "CrossReference record '#{self.id}' was updated. Will now update related Text record: [#{self.text.id}]"
  }
end
