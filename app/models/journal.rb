class Journal < ApplicationRecord
  belongs_to :place, optional: true
  has_many :texts
  default_scope { order(sort_title: :asc) }

  has_paper_trail

  after_commit {
    puts "Journal record '#{self.id}' was updated. Will now touch related Text record(s)"
    self.texts.each(&:touch)
  }

end
