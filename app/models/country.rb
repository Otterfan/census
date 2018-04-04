class Country < ApplicationRecord
  default_scope { order(name: :asc) }
end
