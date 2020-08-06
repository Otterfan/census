module ControlledVocabulary
  extend ActiveSupport::Concern

  included do
    before_save :make_sort_name
  end

  def make_sort_name
    if self.controlled_name
      if name_contains_greek?
        self.sort_name = self.controlled_name
      else
        self.sort_name = ActiveSupport::Inflector.transliterate(self.controlled_name)
      end
    end
  end

  def name_contains_greek?
    !!(self.controlled_name =~ /\p{Greek}/)
  end

end