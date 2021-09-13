module PersonSortable
  extend ActiveSupport::Concern

  included do
    before_save :calculate_sort_full_name
  end

  def calculate_sort_full_name
    I18n.available_locales = [:en]
    candidate_name = self.full_name.nil? ? '' : self.full_name
    self.sort_full_name = I18n.transliterate(candidate_name)
  end

end