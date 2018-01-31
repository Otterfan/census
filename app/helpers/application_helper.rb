module ApplicationHelper

  def formatted_text(text)
    if !text
      ''
    elsif text.include? '<'
      text
    else
      markdown(text)
    end
  end

  def markdown(text)
    options = {
        filter_html: true,
        hard_wrap: true,
        link_attributes: {rel: 'nofollow', target: "_blank"},
        space_after_headers: true,
        fenced_code_blocks: true
    }

    extensions = {
        autolink: true,
        superscript: true,
        disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end


  def changes(version)
    changes = []

    if version.respond_to? :changeset
      changeset = version.changeset
    else
      changeset = version.changes
    end

    changeset.each do |key, val|
      from_set = val[0] != '' && !val[0].nil?
      to_set = val[1] != '' && !val[1].nil?

      if key != 'updated_at' && (from_set || to_set)
        change = {
            field: key,
            from: val[0].to_s,
            to: val[1].to_s,
        }
        changes.push(change)
      end
    end
    changes
  end

  def changed_item_url(item)
    if item.is_a?(Text)
      edit_text_path(item)
    elsif item.is_a?(Volume)
      edit_volume_path(item)
    elsif item.is_a?(Person)
      edit_person_path(item)
    elsif item.is_a?(Journal)
      edit_journal_path(item)
    elsif item.is_a?(Place)
      edit_place_path(item)
    else
      ''
    end
  end

  def changed_item_label(item)
    if item.respond_to?(:title)
      item.title
    elsif item.respond_to?(:name)
      item.name
    elsif
      item.respond_to?(:full_name)
      item.full_name
    else
      'unknown item'
    end
  end
end