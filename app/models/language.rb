class Language < ApplicationRecord
  default_scope { order('ordinal ASC') }
end
