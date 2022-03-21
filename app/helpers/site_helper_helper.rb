module SiteHelperHelper
  def in_current_path?(path_substring)
    request.path.start_with?("/#{path_substring}")
  end

  def body_class
    if request.path.start_with?("/admin")
      'admin'
    else
      'public'
    end
  end

  # Person's birth/death dates in "1974-2018" or "b. 1974" format
  def display_dates(person)
    display_date = ''
    if !person.birth.blank? && !person.death.blank?
      display_date = "(#{person.birth}-#{person.death})"
    elsif !person.birth.blank?
      display_date = "(b. #{person.birth})"
    elsif !person.death.blank?
      display_date = "(d. #{person.death})"
    end
    display_date
  end
end
