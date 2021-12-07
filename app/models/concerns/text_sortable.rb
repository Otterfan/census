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
    self.sort_title.strip! # Strip leading and trailing white space.

    # Remove '[sic]'
    self.sort_title.sub!(/\[sic */, '')

    # Remove leading Greek titles
    self.sort_title.sub!(/^«?\p{Greek}.*\/ */, '')

    # Remove 'From' from the start if it looks like it isn't part of the title.
    self.sort_title.sub!(/^["'“‘«]?From: */, '')
    self.sort_title.sub!(/^["'“‘«]?From _ */, '')

    # Remove punctuation.
    self.sort_title.gsub!(/["'“”‘’«»:_.\[\]]/, '')

    # Remove leading articles
    self.sort_title.sub!(/^(An? )|(The )/, '')

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
    return nil if self.date.nil?

    sort_year = self.date[/\d\d\d\d/]
    sort_month = extract_sort_month(self.issue_season_month)
    sort_day = extract_sort_day(self.issue_season_month)

    self.sort_date = "#{sort_year}-#{sort_month}-#{sort_day}"
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

  def extract_sort_month(issue_season_month)
    return '01' if issue_season_month.nil?

    issue_season_month = issue_season_month.downcase
    if issue_season_month.include? 'jan'
      '01'
    elsif issue_season_month.include? 'feb'
      '02'
    elsif issue_season_month.include? 'mar'
      '03'
    elsif issue_season_month.include? 'apr'
      '04'
    elsif issue_season_month.include? 'may'
      '05'
    elsif issue_season_month.include? 'jun'
      '06'
    elsif issue_season_month.include? 'jul'
      '07'
    elsif issue_season_month.include? 'aug'
      '08'
    elsif issue_season_month.include? 'sep'
      '09'
    elsif issue_season_month.include? 'oct'
      '10'
    elsif issue_season_month.include? 'nov'
      '11'
    elsif issue_season_month.include? 'dec'
      '12'
    elsif issue_season_month.include? 'spring'
      '04'
    elsif issue_season_month.include? 'summer'
      '07'
    elsif issue_season_month.include? 'autu'
      '10'
    elsif issue_season_month.include? 'fall'
      '10'
    elsif issue_season_month.include? 'wint'
      '12'
    else
      '01'
    end
  end

  def extract_sort_day(issue_season_month)
    return '01' if issue_season_month.nil?

    # Extract first number and assume it's a day
    day = issue_season_month[/\d*/]
    return '01' if day == ''

    day.rjust(2, '0')
  end

end