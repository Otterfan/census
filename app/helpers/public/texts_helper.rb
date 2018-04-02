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
        start_tag = ! start_tag
      end
      retval = retval << c
    end
    retval.html_safe
  end

  def format_label(value)
    unless value
      return value
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
end
