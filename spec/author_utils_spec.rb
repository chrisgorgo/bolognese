# frozen_string_literal: true

require 'spec_helper'

describe Bolognese::Metadata, vcr: true do
  let(:input) { "https://doi.org/10.1101/097196" }

  subject { Bolognese::Metadata.new(input: input, from: "crossref") }

  context "is_personal_name?" do
    it "has type organization" do
      author = {"email"=>"info@ucop.edu", "name"=>"University of California, Santa Barbara", "role"=>{"namespace"=>"http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode", "roleCode"=>"copyrightHolder"}, "nameType"=>"Organizational" }
      expect(subject.is_personal_name?(author)).to be false
    end

    it "has id" do
      author = {"id"=>"http://orcid.org/0000-0003-1419-2405", "givenName"=>"Martin", "familyName"=>"Fenner", "name"=>"Martin Fenner" }
      expect(subject.is_personal_name?(author)).to be true
    end

    it "has orcid id" do
      author = { "creatorName"=>"Fenner, Martin", "givenName"=>"Martin", "familyName"=>"Fenner", "nameIdentifier"=>{"schemeURI"=>"http://orcid.org/", "nameIdentifierScheme"=>"ORCID", "__content__"=>"0000-0003-1419-2405"}}
      expect(subject.is_personal_name?(author)).to be true
    end
    it "has family name" do
      author = {"givenName"=>"Martin", "familyName"=>"Fenner", "name"=>"Martin Fenner" }
      expect(subject.is_personal_name?(author)).to be true
    end

    it "has comma" do
      author = {"name"=>"Fenner, Martin" }
      expect(subject.is_personal_name?(author)).to be true
    end

    it "has known given name" do
      author = {"name"=>"Martin Fenner" }
      expect(subject.is_personal_name?(author)).to be true
    end

    it "has no info" do
      author = {"name"=>"M Fenner" }
      expect(subject.is_personal_name?(author)).to be false
    end
  end

  context "get_one_author" do
    it "has familyName" do
      input = "https://doi.org/10.5438/4K3M-NYVG"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0003-1419-2405", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Fenner, Martin", "givenName"=>"Martin", "familyName"=>"Fenner")
    end

    it "has name in sort-order" do
      input = "https://doi.org/10.5061/dryad.8515"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator").first)
      expect(response).to eq("nameType"=>"Personal", "name"=>"Ollomo, Benjamin", "givenName"=>"Benjamin", "familyName"=>"Ollomo")
    end

    it "has name in display-order" do
      input = "https://doi.org/10.5281/ZENODO.48440"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("nameType"=>"Personal", "name"=>"Garza, Kristian", "givenName"=>"Kristian", "familyName"=>"Garza")
    end

    it "has name in display-order with ORCID" do
      input = "https://doi.org/10.6084/M9.FIGSHARE.4700788"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0003-4881-1606", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Bedini, Andrea", "givenName"=>"Andrea", "familyName"=>"Bedini")
    end

    it "has name in Thai" do
      input = "https://doi.org/10.14457/KMITL.res.2006.17"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("name"=>"กัญจนา แซ่เตียว")
    end

    it "multiple author names in one field" do
      input = "https://doi.org/10.7910/dvn/eqtqyo"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_authors(meta.dig("creators", "creator"))
      expect(response).to eq([{"name" => "Enos, Ryan (Harvard University); Fowler, Anthony (University Of Chicago); Vavreck, Lynn (UCLA)"}])
    end

    it "hyper-authorship" do
      input = "https://doi.org/10.17182/HEPDATA.77274.V1"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_authors(meta.dig("creators", "creator"))
      expect(response.length).to eq(1000)
      expect(response.first).to eq("nameType"=>"Personal", "name"=>"Adam, Jaroslav", "givenName"=>"Jaroslav", "familyName"=>"Adam", "affiliation" => "Prague, Tech. U.")
    end

    it "is organization" do
      author = {"email"=>"info@ucop.edu", "creatorName"=> { "__content__" => "University of California, Santa Barbara", "nameType" => "Organizational" }, "role"=>{"namespace"=>"http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode", "roleCode"=>"copyrightHolder"} }
      response = subject.get_one_author(author)
      expect(response).to eq("nameType"=>"Organizational", "name"=>"University Of California, Santa Barbara")
    end

    it "name with affiliation" do
      input = "10.11588/DIGLIT.6130"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("nameType"=>"Organizational", "name"=>"Dr. Störi, Kunstsalon")
    end

    it "name with affiliation and country" do
      input = "10.16910/jemr.9.1.2"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator").first)
      expect(response).to eq("name"=>"Eraslan, Sukru; University Of Manchester, UK, & Middle East Technical University, Northern Cyprus Campus,  Kalkanli, Guzelyurt, Turkey")
    end

    it "name with role" do
      input = "10.14463/GBV:873056442"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator").first)
      expect(response).to eq("nameType"=>"Personal", "name"=>"Schumacher, H. C.", "givenName"=>"H. C.", "familyName"=>"Schumacher")
    end

    it "multiple name_identifier" do
      input = "10.24350/CIRM.V.19028803"
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("nameType"=>"Personal", "name"=>"Dubos, Thomas", "givenName"=>"Thomas", "familyName"=>"Dubos", "affiliation" => "École Polytechnique\nLaboratoire de Météorologie Dynamique", "nameIdentifiers" => [{"nameIdentifier"=>"http://isni.org/isni/0000 0003 5752 6882", "nameIdentifierScheme"=>"ISNI", "schemeUri"=>"http://isni.org/isni/"}, {"nameIdentifier"=>"https://orcid.org/0000-0003-4514-4211", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}])
    end

    it "nameType organizational" do
      input = fixture_path + 'gtex.xml'
      subject = Bolognese::Metadata.new(input: input, from: "datacite")
      meta = Maremma.from_xml(subject.raw).fetch("resource", {})
      response = subject.get_one_author(meta.dig("creators", "creator"))
      expect(response).to eq("nameType"=>"Organizational", "name"=>"The GTEx Consortium")
    end

    it "only familyName and givenName" do
      input = "https://doi.pangaea.de/10.1594/PANGAEA.836178"
      subject = Bolognese::Metadata.new(input: input, from: "schema_org")
      expect(subject.creators.first).to eq("nameType" => "Personal", "name"=>"Johansson, Emma", "givenName"=>"Emma", "familyName"=>"Johansson")
    end
  end

  context "authors_as_string" do
    let(:author_with_organization) { [{"type"=>"Person",
                                       "id"=>"http://orcid.org/0000-0003-0077-4738",
                                       "name"=>"Matt Jones"},
                                      {"type"=>"Person",
                                       "id"=>"http://orcid.org/0000-0002-2192-403X",
                                       "name"=>"Peter Slaughter"},
                                      {"type"=>"Organization",
                                       "id"=>"http://orcid.org/0000-0002-3957-2474",
                                       "name"=>"University of California, Santa Barbara"}] }

    it "author" do
      response = subject.authors_as_string(subject.creators)
      expect(response).to eq("Fenner, Martin and Crosas, Mercè and Grethe, Jeffrey and Kennedy, David and Hermjakob, Henning and Rocca-Serra, Philippe and Durand, Gustavo and Berjon, Robin and Karcher, Sebastian and Martone, Maryann and Clark, Timothy")
    end

    it "single author" do
      response = subject.authors_as_string(subject.creators.first)
      expect(response).to eq("Fenner, Martin")
    end

    it "no author" do
      response = subject.authors_as_string(nil)
      expect(response).to be_nil
    end

    it "with organization" do
      response = subject.authors_as_string(author_with_organization)
      expect(response).to eq("Matt Jones and Peter Slaughter and {University of California, Santa Barbara}")
    end
  end
end
