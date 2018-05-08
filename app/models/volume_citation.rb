class VolumeCitation < ApplicationRecord
  belongs_to :volume
  belongs_to :from_language, class_name: 'Language', foreign_key: 'from_language', optional: true
  belongs_to :to_language, class_name: 'Language', foreign_key: 'to_language', optional: true

  after_commit {
    puts "VolumeCitation record '#{self.id}' was updated. Will now update related Volume record: [#{self.volume.id}]"
  }
end
