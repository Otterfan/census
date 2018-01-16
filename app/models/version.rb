class Version < ApplicationRecord
  paginates_per 60

  def changes
    if object_changes
      @changes ||= YAML.load(object_changes)
    else
      []
    end
  end
end
