class CountryList
  def initialize
    @countries = {}
    @count = {}
  end

  # @param [Country] country
  def add_country(country)
    if has_country(country)
      @count[country.al3_code] = @count[country.al3_code] + 1
    else
      @count[country.al3_code] = 1
      @countries[country.al3_code] = country
    end
  end

  # @param [Country] country
  def has_country(country)
    @count.key?(country.al3_code) && @count[country.al3_code] > 0
  end

  def by_name
    @countries.sort_by {|code, country| country.name }
  end

  def names
    names = []
    @countries.values.each do |country|
      names.push(country.name)
    end
    names
  end

  # @param [Country] country
  def count(country)
    @count[country.al3_code].nil? ? 0 : @count[country.al3_code]
  end
end