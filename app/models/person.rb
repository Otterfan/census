class Person < ApplicationRecord
  has_many :components, through: :component_citations

  paginates_per 60

end
