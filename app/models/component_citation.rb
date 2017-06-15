class ComponentCitation < ApplicationRecord
  belongs_to :component
  belongs_to :person
  belongs_to :role
end
