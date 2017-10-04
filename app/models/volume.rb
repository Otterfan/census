class Volume < ApplicationRecord
  default_scope { order(sort_title: :asc) }
end
