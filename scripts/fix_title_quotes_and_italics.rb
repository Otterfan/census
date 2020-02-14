Text.where('created_at > ?', '2010-01-01').each do |text|
    next if text.title.include? '"'
    next if text.title.include? '_'

    last_original_part = 1

    if text.original
        original_parts = text.original.split('.')
        new_title = original_parts[last_original_part].strip

        if new_title.size < 4
            last_original_part = last_original_part + 1
            new_title = "#{new_title}.#{original_parts[last_original_part]}"
        end

        if new_title.count('_').odd?
            new_title = "#{new_title}_"
        end

        if new_title.count('""').odd?
            new_title = "#{new_title}\""
        end

        if new_title.size > 8
            text.title = new_title
            text.save
            puts "New title is #{new_title}"
            sleep(1)
        end
    end
end
