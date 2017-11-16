class Volume < ApplicationRecord
  default_scope { order(sort_title: :asc) }

  has_many :texts

  has_paper_trail

end
