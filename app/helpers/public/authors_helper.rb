module Public::AuthorsHelper
  def years_list(author)
    author.translations_years.join ', '
  end

  def earliest_translation(author)
    author.translations_years.min.to_i - 1
  end

  def latest_translation(author)
    author.translations_years.max.to_i + 1
  end

  def country_code_list(author)
    codes = author.translation_countries.keys.map {|code| "\"#{code}\""}
    codes.join(', ').html_safe
  end

  def country_count_list(author)
    author.translation_countries.values
  end
end
