class PublicationPlace < ApplicationRecord
  belongs_to :text
  belongs_to :place
end
