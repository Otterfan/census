class Component < ApplicationRecord
  belongs_to :text
  has_many :people, through: :component_citations
end
