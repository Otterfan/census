class CountryList

  @@eu_synonyms = ["European Union", "EU", "E.U."]

  @@country_synonyms = {
    "AUT" => @@eu_synonyms,
    "BEL" => @@eu_synonyms,
    "BGR" => @@eu_synonyms,
    "CYP" => @@eu_synonyms,
    "CZE" => @@eu_synonyms,
    "DEU" => @@eu_synonyms,
    "DNK" => @@eu_synonyms,
    "ESP" => @@eu_synonyms,
    "EST" => @@eu_synonyms,
    "FIN" => @@eu_synonyms,
    "FRA" => @@eu_synonyms,
    "GBR" => %w[UK U.K.],
    "GRC" => @@eu_synonyms,
    "HRV" => @@eu_synonyms,
    "HUN" => @@eu_synonyms,
    "IRL" => @@eu_synonyms,
    "ITL" => @@eu_synonyms,
    "JAP" => %w[Nippon],
    "LTU" => @@eu_synonyms,
    "LUX" => @@eu_synonyms,
    "LVA" => @@eu_synonyms,
    "MLT" => @@eu_synonyms,
    "NLD" => @@eu_synonyms,
    "NZL" => %w[NZ N.Z.],
    "POL" => @@eu_synonyms,
    "PRT" => @@eu_synonyms,
    "ROU" => @@eu_synonyms,
    "SVK" => @@eu_synonyms,
    "SVN" => @@eu_synonyms,
    "SWE" => @@eu_synonyms,
    "TUR" => %w[Türkiye Turkiye],
    "USA" => %w[US U.S. USA U.S.A],
  }

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
    @countries.sort_by { |code, country| country.name }
  end

  # Return a list of country names
  # @return [String]
  def names
    names = []
    @countries.values.each do |country|
      names.push(country.name)
      unless @@country_synonyms[country.al3_code].nil?
        names.concat(@@country_synonyms[country.al3_code])
      end
    end
    names.sort
  end

  # @param [Country] country
  def count(country)
    @count[country.al3_code].nil? ? 0 : @count[country.al3_code]
  end
end