class Component < ApplicationRecord
  belongs_to :text
  has_many :component_citations
  accepts_nested_attributes_for :component_citations,  reject_if: :all_blank, :allow_destroy => true

  default_scope { order("ordinal ASC") }
end
