class ComponentCitation < ApplicationRecord
  belongs_to :component
  belongs_to :from_language, class_name: 'Language', foreign_key: 'from_language', optional: true
  belongs_to :to_language, class_name: 'Language', foreign_key: 'to_language', optional: true

  after_commit {
    puts "ComponentCitation record '#{self.id}' was updated. Will now update related Component record: [#{self.component.id}]"
  }
end
