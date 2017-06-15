class Person < ApplicationRecord
  has_many :components, through: :component_citations
end
