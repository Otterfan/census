class TextCitation < ApplicationRecord
  belongs_to :text
  belongs_to :role, optional: true
end
