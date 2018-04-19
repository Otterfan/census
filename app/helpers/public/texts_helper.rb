require 'uri'

module Public::TextsHelper
  def metadata_row(label, value)
    unless value && value != ''
      return
    end

    dt = "<dt>#{label}</dt>"
    dd = ""
    Array(value).each do |val|
      dd = dd + "<dd>#{convert_underscores(val)}</dd>"
    end

    full = dt + dd
    full.html_safe
  end

  # Convert words wrapped in underscores to <em>
  def convert_underscores(value)
    unless value
      return value
    end

    retval = ""
    start_tag = true

    value.each_char do |c|
      if c == '_'
        c = start_tag ? '<em>' : '</em>'
        start_tag = !start_tag
      end
      retval = retval << c
    end
    retval.html_safe
  end

  def format_label(value)
    unless value
      return value
    end

    value = value.to_s

    # make label changes
    # https://github.com/BCDigSchol/census/issues/140
    case value.downcase
    when "study_part"
      value = "Study (item or component)"
    when "study_book"
      value = "Study (volume)"
    when "translation_part"
      value = "Translation (item or component)"
    when "translation_book"
      value = "Translation (volume)"
    end

    if value.include?("_")
      value.gsub('_', ' ').capitalize
    elsif value == value.downcase
      value.capitalize
    else
      value
    end
  end

  # it is necessary to change the page param to '1' when facet filters are applied or removed
  def reset_page_number_in_path(path)
    unless path
      return path
    end

    path.gsub(/page=\d+/, 'page=1')
  end

  # remove facet from url params when facet filter is removed from the query
  def reset_facet_path(path, facet_name)
    unless path or facet_name
      return path
    end

    # TODO tighten up these regex commands - match string up through next '&' char or end of string
    new_path = path.gsub(/#{facet_name}=.*?(&|$)/, '')
                   .gsub(/&$/, '')

    reset_page_number_in_path(new_path)
  end

  def reset_date_range_facet_path(path, facet_earliest, facet_latest)
    unless path or facet_earliest or facet_latest
      return path
    end

    # clear out each facet from url
    updated_path = reset_facet_path(path, facet_earliest)
    reset_facet_path(updated_path, facet_latest)
  end

  # append the facet into the url when facet filter is applied to the query
  def update_facet_path(path, facet_name, facet_value = "")
    unless path or facet_name
      return path
    end

    url_encoded_facet_value = URI.encode(facet_value)

    new_path = "#{path}&#{facet_name}=#{url_encoded_facet_value}"

    reset_page_number_in_path(new_path)
  end

  # Link to journal from text search result
  def link_to_journal_from_search(journal_hash)
    link_to journal_hash.title, public_journal_path(journal_hash.id)
  end

  # Link to volume from text search result
  def link_to_volume_from_search(volume_hash)
    link_to volume_hash.title, public_volume_path(volume_hash.id)
  end

  # Formatted journal volume and issue
  def formatted_journal_issue(text)
    retval = ''

    if !text.issue_volume.blank? && !text.issue_number.blank?
      retval = "#{text.issue_volume}.#{text.issue_number}"
    elsif text.issue_volume
      retval = "#{text.issue_volume}"
    elsif text.issue_number
      retval = "#{text.issue_number}"
    end

    if !text.issue_season_month.blank?
      retval = "#{retval} (#{text.issue_season_month} #{text.date})"
    end

    if !text.page_span.blank?
      retval = "#{retval}: #{text.page_span}"
    end

    retval
  end
end
