class Tagging < ApplicationRecord
  belongs_to :text
  belongs_to :tag
end
