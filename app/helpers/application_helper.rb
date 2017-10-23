module ApplicationHelper
  def markdown(text)
    options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow', target: "_blank" },
        space_after_headers: true,
        fenced_code_blocks: true
    }

    extensions = {
        autolink:           true,
        superscript:        true,
        disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end


  def changes(version)
    changes = []
    version.changeset.each do |key, val|
      from_set = val[0] != '' && ! val[0].nil?
      to_set = val[1] != '' && ! val[1].nil?

      if key != 'updated_at' && (from_set || to_set)
        change = {
            field: key,
            from: val[0],
            to: val[1],
        }
        changes.push(change)
      end
    end
    changes
  end
end