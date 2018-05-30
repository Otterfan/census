module SiteHelperHelper
  def in_current_path?(path_substring)
    request.path.start_with?("/#{path_substring}")
  end

  def body_class
    request.path.start_with?("/public") ? 'public' : 'admin'
  end

  # Person's birth/death dates in "1974-2018" or "b. 1974" format
  def display_dates(person)
      display_date = ''
      if person.birth && person.death
        display_date = "#{person.birth}-#{person.death}"
      elsif person.birth
        display_date = "b. #{person.birth}"
      elsif person.death
        display_date = "d. #{person.birth}"
      end
      display_date
  end
end
