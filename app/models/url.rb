class Url < ApplicationRecord
  belongs_to :text
  validates_uniqueness_of :value, scope: :text_id
end
