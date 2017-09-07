class Language < ApplicationRecord
  has_many :texts, through: :other_text_languages
  default_scope { order('ordinal ASC') }
end
