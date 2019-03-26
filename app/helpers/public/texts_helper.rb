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
      value = "Study (component)"
    when "study_book"
      value = "Study (volume)"
    when "translation_part"
      value = "Translation (component)"
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
    else
      retval = "#{retval} (#{text.date})"
    end

    if !text.page_span.blank?
      retval = "#{retval}: #{text.page_span}"
    end

    retval
  end

  # add in ellipses for record search results highlighting
  def ellipses_for_highlights(params_highlight, params_original)
    # http://www.concept47.com/austin_web_developer_blog/craftsmanship/showing-better-highlighted-search-result-fragments-with-elasticsearch/
    highlighted_items = []

    if not params_highlight
      return ""
    end

    len = params_highlight.length

    params_highlight.each_with_index do |match, idx|
      # have to do this because highlighted stuff from ES has a trailing space for whatever reason
      stripped_highlighted_item = strip_tags(match).rstrip

      # if the beginning of the highlighted text doesn't match the original it has been clipped
      tmp = params_original =~ /#{Regexp.escape(stripped_highlighted_item)}/
      front_ellipsis = tmp != 0

      # if the last 10 characters of the highlighted text don't match the original, same deal
      # back_ellipsis = last_string_chars(stripped_highlighted_item, 10) != last_string_chars(params_original, 10)
      back_ellipsis = stripped_highlighted_item.split(//).last(10).join != params_original.split(//).last(10).join

      if idx == 0 and front_ellipsis
        highlighted_items << ""
      end

      if front_ellipsis
        highlighted_items << match
      elsif back_ellipsis
        highlighted_items << match
      end

      if idx + 1 == len and back_ellipsis
        highlighted_items << ""
      end
    end

    highlighted_items.join("  &hellip;  ").strip
  end

  # Packages a list of components into a list of collections.
  def components_by_collection(components)
    collections = []
    collection = {
        title: nil,
        components: []
    }
    components.order(:ordinal, :pages, :id).each do |component|
      if component.collection != collection[:title] && collection[:components].count > 0
        collections << collection
        collection = {
            title: component.collection,
            components: [component]
        }
      else
        collection[:components] << component
      end
    end
    collections << collection
  end

  # Formatted link to title as used in tombstones
  def tombstone_title_link(text, formatter, hilight)
    if is_search_result? text
      text = Text.find(text.id)
    end

    title_path = public_text_path(text, hl: hilight)
    title_string = text.title.blank? ? "[No title]" : text.title
    authors_names = text.authors.map.map(&:name).join('; ').strip.chomp('.')
    title_string = "#{authors_names}. #{title_string}"
    link_to(formatter.format(title_string), title_path)
  end

  # Returns true if the text is from a search result.
  def is_search_result?(text)
    text.is_a? Elasticsearch::Model::Response::Result
  end

  # Return the census id as it should appear in the page title
  def title_census_id(text)
    if is_search_result?(text) && text.has_key?('highlight') && text.highlight.census_id
      text.highlight.census_id.first.html_safe
    else
      text.census_id
    end
  end
end
