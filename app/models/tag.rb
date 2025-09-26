class Tag < ApplicationRecord
  has_many :taggings
  has_many :texts, through: :taggings
end
