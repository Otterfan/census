class Journal < ApplicationRecord
  belongs_to :place, optional: true
  default_scope { order(sort_title: :asc) }
end
