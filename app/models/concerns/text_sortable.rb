module TextSortable

  extend ActiveSupport::Concern

  included do
    before_save :calculate_sort_title
    before_save :calculate_sort_census_id
    before_save :calculate_sort_page_span
    before_save :calculate_sort_date
    before_save :calculate_sort_author
    before_save :calculate_sort_translator
  end

  def calculate_sort_title
    self.sort_title = self.title
    self.sort_title.strip!  # Strip leading and trailing white space.

    # Remove 'From' from the start if it looks like it isn't part of the title.
    self.sort_title.sub!(/^["'“‘«]?From: */, '')
    self.sort_title.sub!(/^["'“‘«]?From _ */,'')

    # Remove '[sic]'
    self.sort_title.sub!(/\[sic/, '')

    # Remove punctuation.
    self.sort_title.gsub!(/["'“”‘’«»:_.\[\]]/, '')

    # Remove leading articles
    self.sort_title.sub!(/^(An? )|(The )/, '')

    # Remove leading non ASCII characters (removes leading Greek titles)
    self.sort_title.sub!(/^[^A-Za-z]*/, '')

    self.sort_title.downcase!
  end

  def calculate_sort_census_id
    if self.census_id.blank?
      self.sort_census_id = ''
      return
    end

    section_id, text_id = self.census_id.split('.')

    text_major, text_minor = text_id.split('-')

    text_minor ||= 0

    major = section_id.to_s.rjust(2, "0")
    text_major = text_major.to_s.rjust(6, "0")
    text_minor = text_minor.to_s.rjust(6, "0")

    self.sort_census_id = major + text_major + text_minor
  end

  def calculate_sort_page_span()
    if self.page_span
      matches = self.page_span.match /\D*(\d+)/
      unless matches.nil?
        self.sort_page_span = matches[1].to_i
      end
    end
  end

  def calculate_sort_date
    unless self.date.nil?
      sort_date = self.date[/\d\d\d\d/]
      self.sort_date = "#{sort_date}-01-01"
    end
  end

  def calculate_sort_author
    self.sort_author = authors_names.downcase

    if self.sort_author == ''
      self.sort_author = editors_names.join('; ').downcase
    end
  end

  def calculate_sort_translator
    if self.translators_names.empty?
      return ''
    end

    self.sort_translator = translators_names.join(' ').downcase
  end

end