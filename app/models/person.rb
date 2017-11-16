class Person < ApplicationRecord
  has_many :components, through: :component_citations

  has_many :texts, foreign_key: 'topic_author_id'

  paginates_per 60

  has_paper_trail

end
