class TextCitation < ApplicationRecord
  belongs_to :text
  belongs_to :from_language, class_name: 'Language', foreign_key: 'from_language', optional: true
  belongs_to :to_language, class_name: 'Language', foreign_key: 'to_language', optional: true

  default_scope { order("text_citations.ordinal ASC, id ASC") }

  after_commit {
    puts "TextCitation record '#{self.id}' was updated. Will now update related Text record: [#{self.text.id}]"
  }
end
