class Place < ApplicationRecord
  belongs_to :country, optional: true

  has_many :publication_places, inverse_of: :place, :dependent => :delete_all
  has_many :texts, :through => :publication_places, :class_name => 'Text'
  accepts_nested_attributes_for :publication_places, reject_if: :all_blank, :allow_destroy => true

  has_paper_trail

  default_scope {order(name: :asc)}
end
