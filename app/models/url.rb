class Url < ApplicationRecord
  belongs_to :text
  validates_uniqueness_of :value, scope: :text_id

  def top_level_domain
    begin
      parsed_uri = URI.parse(self.value.strip)

    rescue URI::InvalidURIError
      # Just return empty string on bad URIs
      return ''
    end

    PublicSuffix.domain(parsed_uri.hostname)
  end

end
