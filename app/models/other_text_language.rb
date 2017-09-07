class OtherTextLanguage < ApplicationRecord
  belongs_to :text
  belongs_to :language

  accepts_nested_attributes_for :language, :reject_if => :all_blank
end
