class AdvancedSearchQuery
  def initialize(bq_param)
    options = bq_param.split(/--[A-Z]+--/)

    @fields = {}

    options.each do |option|
      option = option[1...-1]
      parts = option.split('::')
      field_name = parts.shift
      @fields[field_name] = parts
    end
  end

  def text_type
    @fields['text_type']
  end

  def material_type
    @fields['material_type']
  end

  def genre
    @fields['genre']
  end
end