class Journal < ApplicationRecord
  belongs_to :place, optional: true
  has_many :texts
  default_scope { order(sort_title: :asc) }

  has_paper_trail

end
