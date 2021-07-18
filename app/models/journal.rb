class Journal < ApplicationRecord
  belongs_to :place, optional: true
  belongs_to :see_journal, :class_name => "Journal", :foreign_key => "see_journal_id", optional: true

  has_many :texts
  default_scope { order(sort_title: :asc) }

  has_paper_trail

  after_commit {
    puts "Journal record '#{self.id}' was updated. Will now touch related Text record(s)"
    self.texts.each(&:touch)
  }

end
