# frozen_string_literal: true

module Bolognese
  module DoiUtils
    def validate_doi(doi)
      doi = Array(/\A(?:(http|https):\/(\/)?(dx\.)?(doi.org|handle.test.datacite.org)\/)?(doi:)?(10\.\d{4,5}\/.+)\z/.match(doi)).last
      # remove non-printing whitespace and downcase
      doi.delete("\u200B").downcase if doi.present?
    end

    def validate_prefix(doi)
      Array(/\A(?:(http|https):\/(\/)?(dx\.)?(doi.org|handle.test.datacite.org)\/)?(doi:)?(10\.\d{4,5}).*\z/.match(doi)).last
    end

    def doi_resolver(doi, options = {})
      sandbox = Array(/handle.test.datacite.org/.match(doi)).last
      sandbox.present? || options[:sandbox] ? "https://handle.test.datacite.org/" : "https://doi.org/"
    end

    def doi_api_url(doi, options = {})
      sandbox = Array(/handle.test.datacite.org/.match(doi)).last
      sandbox.present? || options[:sandbox] ? "https://api.test.datacite.org/dois/" + doi_from_url(doi) : "https://api.datacite.org/dois/" + doi_from_url(doi)
    end

    def normalize_doi(doi, options = {})
      doi_str = validate_doi(doi)
      return nil unless doi_str.present?

      # turn DOI into URL, escape unsafe characters
      doi_resolver(doi, options) + Addressable::URI.encode(doi_str)
    end

    def doi_from_url(url)
      if /\A(?:(http|https):\/\/(dx\.)?(doi.org|handle.test.datacite.org)\/)?(doi:)?(10\.\d{4,5}\/.+)\z/.match(url)
        uri = Addressable::URI.parse(url)
        uri.path.gsub(/^\//, '').downcase
      end
    end

    def doi_as_url(doi)
      "https://doi.org/#{doi}" if doi.present?
    end

    # get DOI registration agency
    def get_doi_ra(doi)
      prefix = validate_prefix(doi)
      return nil if prefix.blank?

      url = "https://doi.org/ra/#{prefix}"
      result = Maremma.get(url)

      result.body.dig("data", 0, "RA")
    end
  end
end
