module Public::JournalsHelper

  # Print a formatted page span with the appropriate p. or pp.
  def formatted_page_span(text)

    # No page span? Return nothing
    unless text.page_span
      return ''
    end

    # Already a "p." in the page span? Just return the field value.
    if text.page_span.include?('p')
      prefix = ""
    elsif text.page_span.include?('-') || text.page_span.include?(',')
      prefix = "pp."
    else
      prefix = "p."
    end

    "#{prefix} #{text.page_span}"
  end

end
