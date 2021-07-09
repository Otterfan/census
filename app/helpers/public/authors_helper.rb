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

  def translation_dates_y_axis(author) end

  def country_code_list(author)
    codes = author.translation_countries.keys.map { |code| "\"#{code}\"" }
    codes.join(', ').html_safe
  end

  def country_count_list(author)
    author.translation_countries.values
  end

  def alt_name_list(author)
    author.alternate_name.split("\n")
  end

  def active_class_notice(target)
    @current_page == target ? 'class=active' : ''
  end

  def text_classifier(text)
    if text.text_type.include? 'study'
      text.material_type
    elsif text.genre && text.genre.kind_of?(Array)
      text.genre.join(', ')
    elsif text.genre
      text.genre
    end
  end

  def page_count(text)
    if text.text_type.include?('book') && text.page_count
      value = text.page_count.gsub(/.*,(.*)/, '\1')
      if value == ''
        value = nil
      end
    else
      value = nil
    end
    value
  end
end
