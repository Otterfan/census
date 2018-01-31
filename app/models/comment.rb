class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :text

  paginates_per 10

end
