class Volume < ApplicationRecord
  default_scope { order(sort_title: :asc) }

  has_many :texts
  has_many :volume_citations, inverse_of: :volume, :dependent => :delete_all

  accepts_nested_attributes_for :volume_citations, reject_if: :all_blank, :allow_destroy => true

  has_paper_trail

  after_commit {
    puts "Volume record '#{self.id}' was updated. Will now touch related Text record(s)"
    self.texts.each(&:touch)
  }

end
