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
end
