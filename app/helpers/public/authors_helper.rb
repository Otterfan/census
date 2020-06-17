module Public::AuthorsHelper
  def years_list(author)
    author.translations_years.sort.join ', '
  end

  def earliest_translation(author)
    author.translations_years.min.to_i - 1
  end

  def latest_translation(author)
    author.translations_years.max.to_i + 1
  end

  def translation_dates_x_axis(author)
    earliest_year = author.translations_years.min.to_i
    latest_year = author.translations_years.min.to_i
  end

  def translation_dates_y_axis(author)

  end

  def country_code_list(author)
    codes = author.translation_countries.keys.map {|code| "\"#{code}\""}
    codes.join(', ').html_safe
  end

  def country_count_list(author)
    author.translation_countries.values
  end

  def alt_name_list(author)
    author.alternate_name.split("\n")
  end
end
