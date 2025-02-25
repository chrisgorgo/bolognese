# frozen_string_literal: true

require 'spec_helper'

describe Bolognese::Metadata, vcr: true do
  let(:input) { "https://doi.org/10.5061/DRYAD.8515" }

  subject { Bolognese::Metadata.new(input: input) }

  context "get datacite raw" do
    it "BlogPosting" do
      input = fixture_path + 'datacite.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.raw).to eq(IO.read(input).strip)
    end
  end

  context "get datacite metadata" do
    it "Dataset" do
      expect(subject.valid?).to be true
      expect(subject.url).to eq("http://datadryad.org/resource/doi:10.5061/dryad.8515")
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("DataPackage")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.types["ris"]).to eq("DATA")
      expect(subject.types["citeproc"]).to eq("dataset")
      expect(subject.creators.length).to eq(8)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "name"=>"Ollomo, Benjamin", "givenName"=>"Benjamin", "familyName"=>"Ollomo")
      expect(subject.titles).to eq([{"title"=>"Data from: A new malaria agent in African hominids."}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5061/dryad.8515", "identifierType"=>"DOI"},
        {"identifier"=>
            "Ollomo B, Durand P, Prugnolle F, Douzery EJP, Arnathau C, Nkoghe D, Leroy E, Renaud F (2009) A new malaria agent in African hominids. PLoS Pathogens 5(5): e1000446.",
         "identifierType"=>"citation"}])
      expect(subject.rights_list).to eq([{"rightsUri"=>"http://creativecommons.org/publicdomain/zero/1.0"}])
      expect(subject.publication_year).to eq("2011")
      expect(subject.related_identifiers.length).to eq(6)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"19478877", "relatedIdentifierType"=>"PMID", "relationType"=>"IsSupplementTo")
      expect(subject.publisher).to eq("Dryad Digital Repository")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "BlogPosting" do
      input = "https://doi.org/10.5438/4K3M-NYVG"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceType"]).to eq("BlogPosting")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("RPRT")
      expect(subject.types["bibtex"]).to eq("article")
      expect(subject.types["citeproc"]).to eq("article-journal")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "nameIdentifiers"=> [{"nameIdentifier"=>"https://orcid.org/0000-0003-1419-2405", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Fenner, Martin", "givenName"=>"Martin", "familyName"=>"Fenner"}])
      expect(subject.titles).to eq([{"title"=>"Eating your own Dog Food"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/4k3m-nyvg", "identifierType"=>"DOI"}, {"identifier"=>"MS-49-3632-5083", "identifierType"=>"Local accession number"}])
      expect(subject.descriptions.first["description"]).to start_with("Eating your own dog food")
      expect(subject.dates).to eq([{"date"=>"2016-12-20", "dateType"=>"Created"}, {"date"=>"2016-12-20", "dateType"=>"Issued"}, {"date"=>"2016-12-20", "dateType"=>"Updated"}])
      expect(subject.publication_year).to eq("2016")
      expect(subject.related_identifiers.length).to eq(3)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5438/0000-00ss", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf")
      expect(subject.publisher).to eq("DataCite")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "date" do
      input = "https://doi.org/10.4230/lipics.tqc.2013.93"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceType"]).to eq("ConferencePaper")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Johnston, Nathaniel", "givenName"=>"Nathaniel", "familyName"=>"Johnston"}])
      expect(subject.titles).to eq([{"title"=>"The Minimum Size of Qubit Unextendible Product Bases"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.4230/lipics.tqc.2013.93", "identifierType"=>"DOI"}])
      expect(subject.descriptions.first["description"]).to start_with("We investigate the problem of constructing unextendible product bases in the qubit case")
      expect(subject.dates).to eq([{"date"=>"2013-11-05", "dateType"=>"Available"}, {"date"=>"2013", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2013")
      expect(subject.publisher).to eq("Schloss Dagstuhl - Leibniz-Zentrum fuer Informatik GmbH, Wadern/Saarbruecken, Germany")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-2.1")
    end

    it "xs:string attributes" do
      input = "https://doi.org/10.17630/bb43e6a3-72e0-464c-9fdd-fbe5d3e56a09"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Audiovisual")
      expect(subject.creators.length).to eq(14)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "name"=>"Haywood, Raphaelle Dawn", "givenName"=>"Raphaelle Dawn", "familyName"=>"Haywood", "affiliation" => "School of Physics and Astronomy")
      expect(subject.titles).to eq([{"lang"=>"en", "title"=>"Data underpinning - The Sun as a planet-host star: Proxies from SDO images for HARPS radial-velocity variations"}])
      expect(subject.dates).to eq([{"date"=>"2016-01-20", "dateType"=>"Available"}, {"date"=>"2016", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2016")
      expect(subject.publisher).to eq("University of St Andrews")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "multiple licenses" do
      input = "https://doi.org/10.5281/ZENODO.48440"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5281/zenodo.48440", "identifierType"=>"DOI"}, {"identifier"=>"https://zenodo.org/record/48440", "identifierType"=>"URL"}])
      expect(subject.types["schemaOrg"]).to eq("SoftwareSourceCode")
      expect(subject.types["resourceTypeGeneral"]).to eq("Software")
      expect(subject.types["ris"]).to eq("COMP")
      expect(subject.types["citeproc"]).to eq("article")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Garza, Kristian", "givenName"=>"Kristian", "familyName"=>"Garza"}])
      expect(subject.titles).to eq([{"title"=>"Analysis Tools For Crossover Experiment Of Ui Using Choice Architecture"}])
      expect(subject.descriptions.first["description"]).to start_with("This tools are used to analyse the data produced by the Crosssover Experiment")
      expect(subject.rights_list).to eq([{"rights"=>"Creative Commons Attribution-NonCommercial-ShareAlike", "rightsUri"=>"https://creativecommons.org/licenses/by-nc-sa/4.0"},{"rights"=>"Open Access", "rightsUri"=>"info:eu-repo/semantics/openAccess"}])
      expect(subject.dates).to eq([{"date"=>"2016-03-27", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2016")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"https://github.com/kjgarza/frame_experiment_analysis/tree/v1.0", "relatedIdentifierType"=>"URL", "relationType"=>"IsSupplementTo")
      expect(subject.publisher).to eq("Zenodo")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "is identical to" do
      input = "10.6084/M9.FIGSHARE.4234751.V1"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.6084/m9.figshare.4234751.v1", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators.count).to eq(11)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0002-2410-9671", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Junge, Alexander", "givenName"=>"Alexander", "familyName"=>"Junge")
      expect(subject.titles).to eq([{"title"=>"RAIN v1"}])
      expect(subject.descriptions.first["description"]).to start_with("<b>RAIN: RNA–protein Association and Interaction Networks")
      expect(subject.rights_list).to eq([{"rightsUri"=>"https://creativecommons.org/licenses/by/4.0", "rights"=>"CC-BY"}])
      expect(subject.dates).to eq([{"date"=>"2016-11-16", "dateType"=>"Created"}, {"date"=>"2016-11-16", "dateType"=>"Updated"}, {"date"=>"2016", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2016")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.6084/m9.figshare.4234751", "relatedIdentifierType"=>"DOI", "relationType"=>"IsIdenticalTo")
      expect(subject.publisher).to eq("Figshare")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
    end

    it "funding schema version 3" do
      input = "https://doi.org/10.5281/ZENODO.1239"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5281/zenodo.1239", "identifierType"=>"DOI"}, {"identifier"=>"https://zenodo.org/record/1239", "identifierType"=>"URL"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators.length).to eq(4)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "name"=>"Jahn, Najko", "givenName"=>"Najko", "familyName"=>"Jahn", "affiliation"=>"Bielefeld University Library")
      expect(subject.titles).to eq([{"title"=>"Publication Fp7 Funding Acknowledgment - Plos Openaire"}])
      expect(subject.descriptions.first["description"]).to start_with("The dataset contains a sample of metadata describing papers")
      expect(subject.dates).to eq([{"date"=>"2013-04-03", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2013")
      expect(subject.publisher).to eq("Zenodo")
      expect(subject.funding_references).to eq([{"awardNumber"=>"246686",
        "awardTitle"=>"Open Access Infrastructure for Research in Europe",
        "awardUri"=>"info:eu-repo/grantAgreement/EC/FP7/246686/",
        "funderIdentifier"=>"https://doi.org/10.13039/501100000780",
        "funderIdentifierType"=>"Crossref Funder ID",
        "funderName"=>"European Commission"}])
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "from attributes" do
      subject = Bolognese::Metadata.new(input: nil,
        from: "datacite",
        doi: "10.5281/zenodo.1239",
        creators: [{"nameType"=>"Personal", "name"=>"Jahn, Najko", "givenName"=>"Najko", "familyName"=>"Jahn"}],
        titles: [{ "title" => "Publication Fp7 Funding Acknowledgment - Plos Openaire" }],
        descriptions: [{ "description" => "The dataset contains a sample of metadata describing papers" }],
        publisher: "Zenodo",
        publication_year: "2013",
        dates: [{"date"=>"2013-04-03", "dateType"=>"Issued"}],
        funding_references: [{"awardNumber"=>"246686",
          "awardTitle"=>"Open Access Infrastructure for Research in Europe",
          "awardUri"=>"info:eu-repo/grantAgreement/EC/FP7/246686/",
          "funderIdentifier"=>"https://doi.org/10.13039/501100000780",
          "funderIdentifierType"=>"Crossref Funder ID",
          "funderName"=>"European Commission"}],
        types: { "resourceTypeGeneral" => "Dataset", "schemaOrg" => "Dataset" })

      puts subject.errors
      
      expect(subject.valid?).to be true
      expect(subject.doi).to eq("10.5281/zenodo.1239")
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5281/zenodo.1239", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{"familyName"=>"Jahn", "givenName"=>"Najko", "name"=>"Jahn, Najko", "nameType"=>"Personal"}])
      expect(subject.titles).to eq([{"title"=>"Publication Fp7 Funding Acknowledgment - Plos Openaire"}])
      expect(subject.descriptions.first["description"]).to start_with("The dataset contains a sample of metadata describing papers")
      expect(subject.dates).to eq([{"date"=>"2013-04-03", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2013")
      expect(subject.publisher).to eq("Zenodo")
      expect(subject.funding_references).to eq([{"awardNumber"=>"246686",
        "awardTitle"=>"Open Access Infrastructure for Research in Europe",
        "awardUri"=>"info:eu-repo/grantAgreement/EC/FP7/246686/",
        "funderIdentifier"=>"https://doi.org/10.13039/501100000780",
        "funderIdentifierType"=>"Crossref Funder ID",
        "funderName"=>"European Commission"}])
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
      expect(subject.state).to eq("findable")
    end

    it "missing resource_type_general" do
      input = fixture_path + 'vivli.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.types["schemaOrg"]).to eq("CreativeWork")
      expect(subject.types["resourceTypeGeneral"]).to be_nil
      expect(subject.valid?).to be false
      expect(subject.errors).to eq("2:0: ERROR: Element '{http://datacite.org/schema/kernel-4}resource': Missing child element(s). Expected is one of ( {http://datacite.org/schema/kernel-4}resourceType, {http://datacite.org/schema/kernel-4}subjects, {http://datacite.org/schema/kernel-4}contributors, {http://datacite.org/schema/kernel-4}language, {http://datacite.org/schema/kernel-4}alternateIdentifiers, {http://datacite.org/schema/kernel-4}relatedIdentifiers, {http://datacite.org/schema/kernel-4}sizes, {http://datacite.org/schema/kernel-4}formats, {http://datacite.org/schema/kernel-4}rightsList, {http://datacite.org/schema/kernel-4}descriptions ).")
    end

    it "multiple languages" do
      input = fixture_path + 'datacite-multiple-language.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.types["schemaOrg"]).to eq("Collection")
      expect(subject.language).to eq("de")
      expect(subject.publisher).to eq("Universitätsbibliothek Tübingen")
      expect(subject.publication_year).to eq("2015")
      expect(subject.valid?).to be false
      expect(subject.errors).to eq("13:0: ERROR: Element '{http://datacite.org/schema/kernel-2.2}publisher': This element is not expected. Expected is ( {http://datacite.org/schema/kernel-2.2}publicationYear ).")
    end

    it "geo_location empty" do
      input = fixture_path + 'datacite-geolocation-empty.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.geo_locations).to eq([{"geoLocationPoint"=>{"pointLatitude"=>"-11.64583333", "pointLongitude"=>"-68.2975"}}])
    end

    it "geo_location in separate input" do
      input = fixture_path + 'datacite-geolocation-empty.xml'
      geo_locations = [{"geoLocationPoint"=>{"pointLatitude"=>"49.0850736", "pointLongitude"=>"-123.3300992"}}]
      subject = Bolognese::Metadata.new(input: input, geo_locations: geo_locations)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.geo_locations).to eq(geo_locations)

      datacite = Maremma.from_xml(subject.datacite).fetch("resource", {})
      expect(datacite.dig("geoLocations")).to eq("geoLocation"=>{"geoLocationPoint"=>{"pointLatitude"=>"49.0850736", "pointLongitude"=>"-123.3300992"}})
    end

    it "xml:lang attribute" do
      input = fixture_path + 'datacite-xml-lang.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Collection")
      expect(subject.titles).to eq([{"lang"=>"en", "title"=>"DOI Test 2 title content"}, {"lang"=>"en", "title"=>"AAPP"}])
      expect(subject.descriptions).to eq([{"description"=>"This is the DOI TEST 2 product where this is the description field content.", "descriptionType"=>"Methods", "lang"=>"en"}])
      expect(subject.geo_locations).to eq([{"geoLocationBox"=>{"eastBoundLongitude"=>"70.0", "northBoundLatitude"=>"70.0", "southBoundLatitude"=>"-70.0", "westBoundLongitude"=>"-70.0"}}, {"geoLocationPlace"=>"Regional"}])
    end

    it "wrong attributes" do
      input = fixture_path + 'nist.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/m32163", "identifierType"=>"DOI"}])
      expect(subject.titles).to eq([{"title"=>"Peter Auto Dataset 501"}])
      expect(subject.descriptions).to eq([{"description"=>"This is to overturn Einstein's Relativity Theory.", "descriptionType"=>"Abstract"}])
      expect(subject.valid?).to be false
      expect(subject.errors.length).to eq(4)
      expect(subject.errors.last).to eq("32:0: ERROR: Element '{http://datacite.org/schema/kernel-3}alternateIdentifier': The attribute 'alternateIdentifierType' is required but missing.")
    end

    it "schema 4.0" do
      input = fixture_path + 'schema_4.0.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.6071/z7wc73", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators.length).to eq(6)
      expect(subject.creators.first).to eq("familyName"=>"Bales", "givenName"=>"Roger", "name"=>"Bales, Roger", "nameType"=>"Personal", "affiliation"=>"UC Merced")
    end

    it "series_information" do
      input = fixture_path + 'datacite-seriesinformation.xml'
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/4k3m-nyvg", "identifierType"=>"DOI"}, {"identifier"=>"MS-49-3632-5083", "identifierType"=>"Local accession number"}])
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("familyName"=>"Fenner", "givenName"=>"Martin", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0003-1419-2405", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Fenner, Martin", "nameType"=>"Personal")
      expect(subject.titles).to eq([{"title"=>"Eating your own Dog Food"}])
      expect(subject.publisher).to eq("DataCite")
      expect(subject.publication_year).to eq("2016")
      expect(subject.related_identifiers).to eq([{"relatedIdentifier"=>"10.5438/0012",
        "relatedIdentifierType"=>"DOI",
        "relationType"=>"References"},
       {"relatedIdentifier"=>"10.5438/55e5-t5c0",
        "relatedIdentifierType"=>"DOI",
        "relationType"=>"References"},
       {"relatedIdentifier"=>"10.5438/0000-00ss",
        "relatedIdentifierType"=>"DOI",
        "relationType"=>"IsPartOf"}])
      expect(subject.descriptions).to eq([{"description"=>"DataCite Blog, 2(9), 3-4",
        "descriptionType"=>"SeriesInformation",
        "lang"=>"en"},
       {"description"=>
        "Eating your own dog food is a slang term to describe that an organization should itself use the products and services it provides. For DataCite this means that we should use DOIs with appropriate metadata and strategies for long-term preservation for...",
        "descriptionType"=>"Abstract"}])
      expect(subject.container).to eq("firstPage"=>"3", "identifier"=>"10.5438/0000-00SS", "identifierType"=>"DOI", "issue"=>"9", "lastPage"=>"4", "title"=>"DataCite Blog", "type"=>"Series", "volume"=>"2")
    end

    it "geo_location" do
      input = fixture_path + 'datacite-example-geolocation.xml'
      doi = "10.5072/geoPointExample"
      subject = Bolognese::Metadata.new(input: input, doi: doi)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/geopointexample", "identifierType"=>"DOI"}])
      expect(subject.doi).to eq("10.5072/geopointexample")
      expect(subject.creators.length).to eq(3)
      expect(subject.creators.first).to eq("familyName"=>"Schumann", "givenName"=>"Kai", "name"=>"Schumann, Kai", "nameType"=>"Personal")
      expect(subject.titles).to eq([{"title"=>"Gridded results of swath bathymetric mapping of Disko Bay, Western Greenland, 2007-2008"}])
      expect(subject.publisher).to eq("PANGAEA - Data Publisher for Earth & Environmental Science")
      expect(subject.publication_year).to eq("2011")
      expect(subject.related_identifiers).to eq([{"relatedIdentifier"=>"10.5072/timeseries", "relatedIdentifierType"=>"DOI", "relationType"=>"Continues"}])
      expect(subject.geo_locations).to eq([{"geoLocationPlace"=>"Disko Bay", "geoLocationPoint"=>{"pointLatitude"=>"69.000000", "pointLongitude"=>"-52.000000"}}])
    end

    it "geo_location_box" do
      input = fixture_path + 'datacite-example-geolocation-2.xml'
      doi = "10.6071/Z7WC73"
      subject = Bolognese::Metadata.new(input: input, doi: doi)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.6071/z7wc73", "identifierType"=>"DOI"}])
      expect(subject.doi).to eq("10.6071/z7wc73")
      expect(subject.creators.length).to eq(6)
      expect(subject.creators.first).to eq("familyName"=>"Bales", "givenName"=>"Roger", "name"=>"Bales, Roger", "nameType"=>"Personal", "affiliation" => ["UC Merced", "NSF"])
      expect(subject.titles).to eq([{"title"=>"Southern Sierra Critical Zone Observatory (SSCZO), Providence Creek\n      meteorological data, soil moisture and temperature, snow depth and air\n      temperature"}])
      expect(subject.publisher).to eq("UC Merced")
      expect(subject.dates).to eq([{"date"=>"2014-10-17", "dateType"=>"Updated"}, {"date"=>"2016-03-14T17:02:02Z", "dateType"=>"Available"}, {"date"=>"2013", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2013")
      expect(subject.geo_locations).to eq([{"geoLocationBox"=>
        {"eastBoundLongitude"=>"-119.182",
         "northBoundLatitude"=>"37.075",
         "southBoundLatitude"=>"37.046",
         "westBoundLongitude"=>"-119.211"},
         "geoLocationPlace"=>"Providence Creek (Lower, Upper and P301)",
         "geoLocationPoint"=>  {"pointLatitude"=>"37.047756", "pointLongitude"=>"-119.221094"}}])
    end

    it "author only full name" do
      input = "https://doi.org/10.14457/KMITL.RES.2006.17"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.14457/kmitl.res.2006.17", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.creators.length).to eq(1)
      expect(subject.creators.first).to eq("name" => "กัญจนา แซ่เตียว")
    end

    it "multiple author names in one creatorsName" do
      input = "https://doi.org/10.7910/DVN/EQTQYO"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.7910/dvn/eqtqyo", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.creators).to eq([{"name" => "Enos, Ryan (Harvard University); Fowler, Anthony (University Of Chicago); Vavreck, Lynn (UCLA)"}])
    end

    it "author with scheme" do
      input = "https://doi.org/10.18429/JACOW-IPAC2016-TUPMY003"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.18429/jacow-ipac2016-tupmy003", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.creators.length).to eq(12)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"http://jacow.org/JACoW-00077389", "nameIdentifierScheme"=>"JACoW-ID", "schemeUri"=>"http://jacow.org/"}], "name"=>"Otani, Masashi", "givenName"=>"Masashi", "familyName"=>"Otani", "affiliation" => "KEK, Tsukuba, Japan")
    end

    it "author with wrong orcid scheme" do
      input = "https://doi.org/10.2314/COSCV1"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.2314/coscv1", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.creators.length).to eq(14)
      expect(subject.creators.first).to include("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0003-0232-7085", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Heller, Lambert", "givenName"=>"Lambert", "familyName"=>"Heller")
    end

    it "keywords with attributes" do
      input = "https://doi.org/10.21233/n34n5q"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.21233/n34n5q", "identifierType"=>"DOI"}])
      expect(subject.subjects).to eq([{"schemeUri"=>"http://id.loc.gov/authorities/subjects", "subject"=>"Paleoecology", "subjectScheme"=>"Library of Congress"}])
    end

    it "Funding" do
      input = "https://doi.org/10.15125/BATH-00114"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.15125/bath-00114", "identifierType"=>"DOI"}, {"identifier"=>"http://researchdata.bath.ac.uk/114/", "identifierType"=>"URL"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0001-8740-8284", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Bimbo, Nuno", "givenName"=>"Nuno", "familyName"=>"Bimbo")
      expect(subject.titles).to eq([{"title"=>"Dataset for \"Direct Evidence for Solid-Like Hydrogen in a Nanoporous Carbon Hydrogen Storage Material at Supercritical Temperatures\""}])
      expect(subject.descriptions.first["description"]).to start_with("Dataset for Direct Evidence for Solid-Like Hydrogen")
      expect(subject.publication_year).to eq("2015")
      expect(subject.publisher).to eq("University of Bath")
      expect(subject.funding_references.length).to eq(5)
      expect(subject.funding_references.first).to eq("awardNumber" => "EP/J016454/1",
        "awardTitle" => "SUPERGEN Hub Funding",
        "funderIdentifier" => "https://doi.org/10.13039/501100000266",
        "funderIdentifierType" => "Crossref Funder ID",
        "funderName" => "Engineering and Physical Sciences Research Council (EPSRC)")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "Funding schema version 4" do
      input = "https://doi.org/10.5438/6423"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/6423", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Collection")
      expect(subject.types["resourceType"]).to eq("Project")
      expect(subject.types["resourceTypeGeneral"]).to eq("Collection")
      expect(subject.types["ris"]).to eq("GEN")
      expect(subject.types["citeproc"]).to eq("article")
      expect(subject.creators.length).to eq(24)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "nameIdentifiers" => [{"nameIdentifier"=>"https://orcid.org/0000-0001-5331-6592", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Farquhar, Adam", "givenName"=>"Adam", "familyName"=>"Farquhar", "affiliation" => "British Library")
      expect(subject.titles).to eq([{"title"=>"Technical and Human Infrastructure for Open Research (THOR)"}])
      expect(subject.descriptions.first["description"]).to start_with("Five years ago, a global infrastructure")
      expect(subject.publication_year).to eq("2015")
      expect(subject.publisher).to eq("DataCite")
      expect(subject.funding_references).to eq([{"awardNumber"=>"654039",
        "awardTitle"=>"THOR – Technical and Human Infrastructure for Open Research",
        "awardUri"=>"http://cordis.europa.eu/project/rcn/194927_en.html",
        "funderIdentifier"=>"https://doi.org/10.13039/501100000780",
        "funderIdentifierType"=>"Crossref Funder ID",
        "funderName"=>"European Commission"}])
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "Funding empty awardTitle" do
      input = "https://doi.org/10.26102/2310-6018/2019.24.1.006"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.26102/2310-6018/2019.24.1.006", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceType"]).to eq("Journal Article")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.creators.length).to eq(2)
      expect(subject.creators.first).to eq("affiliation"=>"Тверская государственная сельскохозяйственная академия", "familyName"=>"Ганичева", "givenName"=>"А.В.", "name"=>"Ганичева, А.В.", "nameType"=>"Personal")
      expect(subject.titles).to eq([{"title"=>"МОДЕЛЬ СИСТЕМНОЙ ДИНАМИКИ ПРОЦЕССА ОБУЧЕНИЯ"}, {"title"=>"MODEL OF SYSTEM DYNAMICS OF PROCESS OF TRAINING", "titleType"=>"TranslatedTitle"}])
      expect(subject.descriptions.first["description"]).to start_with("Актуальность данной работы обусловлена важностью учета в учебном процессе личностных качеств обучаем")
      expect(subject.publication_year).to eq("2019")
      expect(subject.publisher).to eq("МОДЕЛИРОВАНИЕ, ОПТИМИЗАЦИЯ И ИНФОРМАЦИОННЫЕ ТЕХНОЛОГИИ")
      expect(subject.funding_references.length).to eq(1)
      expect(subject.funding_references.first).to eq("awardNumber"=>"проект № 170100728", "funderName"=>"РФФИ")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "BlogPosting from string" do
      input = fixture_path + "datacite.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceType"]).to eq("BlogPosting")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("RPRT")
      expect(subject.types["citeproc"]).to eq("article-journal")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "nameIdentifiers"=> [{"nameIdentifier"=>"https://orcid.org/0000-0003-1419-2405", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Fenner, Martin", "givenName"=>"Martin", "familyName"=>"Fenner"}])
      expect(subject.titles).to eq([{"title"=>"Eating your own Dog Food"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5438/4k3m-nyvg", "identifierType"=>"DOI"}, {"identifier"=>"MS-49-3632-5083", "identifierType"=>"Local accession number"}])
      expect(subject.dates).to eq([{"date"=>"2016-12-20", "dateType"=>"Created"}, {"date"=>"2016-12-20", "dateType"=>"Issued"}, {"date"=>"2016-12-20", "dateType"=>"Updated"}])
      expect(subject.publication_year).to eq("2016")
      expect(subject.related_identifiers.length).to eq(3)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5438/0000-00ss", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf")
      expect(subject.agency).to eq("DataCite")
    end

    it "Schema 4.1 from string" do
      input = fixture_path + "datacite-example-complicated-v4.1.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Book")
      expect(subject.types["resourceType"]).to eq("Monograph")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("BOOK")
      expect(subject.types["citeproc"]).to eq("book")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Smith, John", "givenName"=>"John", "familyName"=>"Smith"}, {"name"=>"つまらないものですが"}])
      expect(subject.titles).to eq([{"title"=>"Właściwości rzutowań podprzestrzeniowych"}, {"title"=>"Translation of Polish titles", "titleType"=>"TranslatedTitle"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/testpub", "identifierType"=>"DOI"}, {"identifier"=>"937-0-4523-12357-6", "identifierType"=>"ISBN"}])
      expect(subject.dates).to eq([{"date"=>"2012-12-13", "dateInformation"=>"Correction", "dateType"=>"Other"}, {"date"=>"2010", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2010")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5272/oldertestpub", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf", "resourceTypeGeneral"=>"Text")
      expect(subject.rights_list).to eq([{"lang"=>"eng", "rightsUri"=>"http://creativecommons.org/licenses/by-nd/2.0", "rights"=>"Creative Commons Attribution-NoDerivs 2.0 Generic"}])
      expect(subject.publisher).to eq("Springer")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "Schema 4.0 from string" do
      input = fixture_path + "datacite-example-complicated-v4.0.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Book")
      expect(subject.types["resourceType"]).to eq("Monograph")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("BOOK")
      expect(subject.types["citeproc"]).to eq("book")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Smith, John", "givenName"=>"John", "familyName"=>"Smith"}, {"name"=>"つまらないものですが"}])
      expect(subject.titles).to eq([{"title"=>"Właściwości rzutowań podprzestrzeniowych"}, {"title"=>"Translation of Polish titles", "titleType"=>"TranslatedTitle"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/testpub", "identifierType"=>"DOI"}, {"identifier"=>"937-0-4523-12357-6", "identifierType"=>"ISBN"}])
      expect(subject.publication_year).to eq("2010")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5272/oldertestpub", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf")
      expect(subject.rights_list).to eq([{"rightsUri"=>"http://creativecommons.org/licenses/by-nd/2.0", "rights"=>"Creative Commons Attribution-NoDerivs 2.0 Generic"}])
      expect(subject.publisher).to eq("Springer")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4.0")
    end

    it "Schema 3 from string" do
      input = fixture_path + "datacite_schema_3.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("DataPackage")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.types["ris"]).to eq("DATA")
      expect(subject.types["citeproc"]).to eq("dataset")
      expect(subject.creators.length).to eq(8)
      expect(subject.creators.last).to eq("familyName"=>"Renaud", "givenName"=>"François", "name"=>"Renaud, François", "nameType"=>"Personal")
      expect(subject.titles).to eq([{"title"=>"Data from: A new malaria agent in African hominids."}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5061/dryad.8515", "identifierType"=>"DOI"},
        {"identifier"=>
            "Ollomo B, Durand P, Prugnolle F, Douzery EJP, Arnathau C, Nkoghe D, Leroy E, Renaud F (2009) A new malaria agent in African hominids. PLoS Pathogens 5(5): e1000446.",
         "identifierType"=>"citation"}])
      expect(subject.publication_year).to eq("2011")
      expect(subject.related_identifiers.length).to eq(4)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"19478877", "relatedIdentifierType"=>"PMID", "relationType"=>"IsReferencedBy")
      expect(subject.rights_list).to eq([{"rightsUri"=>"http://creativecommons.org/publicdomain/zero/1.0"}])
      expect(subject.publisher).to eq("Dryad Digital Repository")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
    end

    it "Schema 3.0 from string" do
      input = fixture_path + "datacite-example-complicated-v3.0.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Book")
      expect(subject.types["resourceType"]).to eq("Monograph")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("BOOK")
      expect(subject.types["citeproc"]).to eq("book")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Smith, John", "givenName"=>"John", "familyName"=>"Smith"}, {"name"=>"つまらないものですが"}])
      expect(subject.titles).to eq([{"title"=>"Właściwości rzutowań podprzestrzeniowych"}, {"title"=>"Translation of Polish titles", "titleType"=>"TranslatedTitle"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/testpub", "identifierType"=>"DOI"}, {"identifier"=>"937-0-4523-12357-6", "identifierType"=>"ISBN"}])
      expect(subject.publication_year).to eq("2010")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5272/oldertestpub", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf")
      expect(subject.rights_list).to eq([{"rightsUri"=>"http://creativecommons.org/licenses/by-nd/2.0", "rights"=>"Creative Commons Attribution-NoDerivs 2.0 Generic"}])
      expect(subject.publisher).to eq("Springer")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3.0")
    end

    it "Schema 2.2 from string" do
      input = fixture_path + "datacite-metadata-sample-complicated-v2.2.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Book")
      expect(subject.types["resourceType"]).to eq("Monograph")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("BOOK")
      expect(subject.types["citeproc"]).to eq("book")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Smith, John", "givenName"=>"John", "familyName"=>"Smith"}, {"name"=>"つまらないものですが"}])
      expect(subject.titles).to eq([{"title"=>"Właściwości rzutowań podprzestrzeniowych"}, {"title"=>"Translation of Polish titles", "titleType"=>"TranslatedTitle"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/testpub", "identifierType"=>"DOI"}, {"identifier"=>"937-0-4523-12357-6", "identifierType"=>"ISBN"}])
      expect(subject.dates).to eq([{"date"=>"2009-04-29", "dateType"=>"StartDate"}, {"date"=>"2010-01-05", "dateType"=>"EndDate"}, {"date"=>"2010", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2010")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5272/oldertestpub", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf")
      expect(subject.publisher).to eq("Springer")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-2.2")
    end

    it "Schema 4.1 from string with doi in options" do
      input = fixture_path + "datacite-example-complicated-v4.1.xml"
      subject = Bolognese::Metadata.new(input: input, doi: "10.5072/testpub2", content_url: "https://example.org/report.pdf")
      expect(subject.valid?).to be true
      expect(subject.types["schemaOrg"]).to eq("Book")
      expect(subject.types["resourceType"]).to eq("Monograph")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Smith, John", "givenName"=>"John", "familyName"=>"Smith"}, {"name"=>"つまらないものですが"}])
      expect(subject.titles).to eq([{"title"=>"Właściwości rzutowań podprzestrzeniowych"}, {"title"=>"Translation of Polish titles", "titleType"=>"TranslatedTitle"}])
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/testpub2", "identifierType"=>"DOI"}, {"identifier"=>"937-0-4523-12357-6", "identifierType"=>"ISBN"}])
      expect(subject.dates).to eq([{"date"=>"2012-12-13", "dateInformation"=>"Correction", "dateType"=>"Other"}, {"date"=>"2010", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2010")
      expect(subject.sizes).to eq(["256 pages"])
      expect(subject.formats).to eq(["pdf"])
      expect(subject.content_url).to eq("https://example.org/report.pdf")
      expect(subject.publication_year).to eq("2010")
      expect(subject.related_identifiers.length).to eq(1)
      expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"10.5272/oldertestpub", "relatedIdentifierType"=>"DOI", "relationType"=>"IsPartOf", "resourceTypeGeneral"=>"Text")
      expect(subject.rights_list).to eq([{"lang"=>"eng", "rightsUri"=>"http://creativecommons.org/licenses/by-nd/2.0", "rights"=>"Creative Commons Attribution-NoDerivs 2.0 Generic"}])
      expect(subject.publisher).to eq("Springer")
      expect(subject.agency).to eq("DataCite")
    end

    it "namespaced xml from string" do
      input = fixture_path + "ns0.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.4231/d38g8fk8b", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("SoftwareSourceCode")
      expect(subject.types["resourceType"]).to eq("Simulation Tool")
      expect(subject.types["resourceTypeGeneral"]).to eq("Software")
      expect(subject.creators.length).to eq(5)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "name"=>"PatiÃ±O, Carlos", "givenName"=>"Carlos", "familyName"=>"PatiÃ±O")
      expect(subject.titles).to eq([{"title"=>"LAMMPS Data-File Generator"}])
      expect(subject.dates).to eq([{"date"=>"2018-07-18", "dateType"=>"Valid"}, {"date"=>"2018-07-18", "dateType"=>"Accepted"}, {"date"=>"2018", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2018")
      expect(subject.publisher).to eq("nanoHUB")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-2.2")
    end

    it "doi with + sign" do
      input = "10.5067/terra+aqua/ceres/cldtyphist_l3.004"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5067/terra+aqua/ceres/cldtyphist_l3.004", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Wong, Takmeng", "givenName"=>"Takmeng", "familyName"=>"Wong"}])
      expect(subject.titles).to eq([{"title"=>"CERES Level 3 Cloud Type Historgram Terra+Aqua HDF file - Edition4"}])
      expect(subject.publication_year).to eq("2016")
      expect(subject.publisher).to eq("NASA Langley Atmospheric Science Data Center DAAC")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "subject scheme" do
      input = "https://doi.org/10.4232/1.2745"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.4232/1.2745", "identifierType"=>"DOI"},
        {"identifier"=>"ZA2745", "identifierType"=>"ZA-No."},
        {"identifier"=>"Internationale Umfrageprogramme", "identifierType"=>"FDZ"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{"nameType"=>"Organizational", "name"=>"Europäische Kommission"}])
      expect(subject.contributors).to eq([{"nameType"=>"Personal", "name"=>"Reif, Karlheinz", "givenName"=>"Karlheinz", "familyName"=>"Reif", "affiliation"=>"Europäische Kommission, Brüssel", "contributorType"=>"Researcher"}, {"nameType"=>"Personal", "name"=>"Jamar, Nicole", "givenName"=>"Nicole", "familyName"=>"Jamar", "affiliation"=>"EOS, Gallup Europe, Chaumont-Gistoux, Belgien", "contributorType"=>"Researcher"}, {"nameType"=>"Organizational", "name"=>"DIMARSO, Bruessel"}, {"nameType"=>"Organizational", "name"=>"GALLUP, Kopenhagen"}, {"nameType"=>"Organizational", "name"=>"EMNID, Bielefeld"}, {"nameType"=>"Organizational", "name"=>"ICAP, Athen"}, {"nameType"=>"Organizational", "name"=>"DEMOSCOPIA, Madrid"}, {"nameType"=>"Organizational", "name"=>"B.V.A., Viroflay, Frankreich"}, {"nameType"=>"Organizational", "name"=>"Irish Marketing Surveys, Dublin"}, {"nameType"=>"Organizational", "name"=>"DOXA, Mailand"}, {"nameType"=>"Organizational", "name"=>"ILRES, Luxemburg"}, {"nameType"=>"Organizational", "name"=>"NIPO, Amsterdam"}, {"nameType"=>"Organizational", "name"=>"METRIS, Lissabon"}, {"nameType"=>"Organizational", "name"=>"NOP, London"}, {"nameType"=>"Organizational", "name"=>"OESTERREICHISCHES GALLUP, Wien"}, {"nameType"=>"Organizational", "name"=>"SUOMEN GALLUP, Espoo, Finnland"}, {"nameType"=>"Organizational", "name"=>"SIFO, Stockholm"}, {"nameType"=>"Organizational", "name"=>"TNS Dimarso, Brüssel TNS GALLUP DK, Kopenhagen EMNID, Bielefeld TNS ICAP, Athen TNS Demoscopia, Madrid B.V.A., Viroflay, Frankreich IRISH MKTG SURVEYS, Dublin DOXA, Mailand TNS ILReS, Luxemburg TNS NIPO, Amsterdam Österreichisches GALLUP, Wien"}])
      expect(subject.titles).to eq([{"lang"=>"de", "title"=>"Flash Eurobarometer 54 (Madrid Summit)"}, {"lang"=>"en", "title"=>"Flash Eurobarometer 54 (Madrid Summit)"}, {"titleType"=>"Subtitle","lang"=>"de", "title"=>"The Common European Currency"}, {"titleType"=>"Subtitle", "lang"=>"en", "title"=>"The Common European Currency"}])
      expect(subject.subjects).to eq([{"subjectScheme"=>"ZA", "lang"=>"en", "subject"=>"KAT12 International Institutions, Relations, Conditions"}])
      expect(subject.dates).to eq([{"date"=>"1995-12", "dateType"=>"Collected"}, {"date"=>"1996", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("1996")
      expect(subject.publisher).to eq("GESIS Data Archive")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "series-information" do
      input = "https://doi.org/10.4229/23RDEUPVSEC2008-5CO.8.3"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.4229/23rdeupvsec2008-5co.8.3", "identifierType"=>"DOI"}, {"identifier"=>"3-936338-24-8", "identifierType"=>"ISBN"}])
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceType"]).to eq("Article")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.creators.length).to eq(3)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "name"=>"Llamas, P.", "givenName"=>"P.", "familyName"=>"Llamas")
      expect(subject.titles).to eq([{"title"=>"Rural Electrification With Hybrid Power Systems Based on Renewables - Technical System Configurations From the Point of View of the European Industry"}])
      expect(subject.dates).to eq([{"date"=>"2008-11-01", "dateType"=>"Valid"}, {"date"=>"2008", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2008")
      expect(subject.container).to eq("firstPage"=>"Spain; 3353", "lastPage"=>"3356", "title"=>"23rd European Photovoltaic Solar Energy Conference and Exhibition", "type"=>"Series", "volume"=>"1-5 September 2008")
      expect(subject.descriptions[1]["description"]).to start_with("Aim of this paper is the presentation")
      expect(subject.publisher).to eq("WIP-Munich")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-2.2")
    end

    it "content url" do
      input = "10.23725/8na3-9s47"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.doi).to eq("10.23725/8na3-9s47")
      expect(subject.identifiers.length).to eq(4)
      expect(subject.identifiers[1]).to eq("identifier"=>"ark:/99999/fk41CrU4eszeLUDe", "identifierType"=>"minid")
      expect(subject.content_url).to include("s3://cgp-commons-public/topmed_open_access/197bc047-e917-55ed-852d-d563cdbc50e4/NWD165827.recab.cram", "gs://topmed-irc-share/public/NWD165827.recab.cram")
    end

    it "empty subject" do
      input = "https://doi.org/10.18169/PAPDEOTTX00502"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.18169/papdeottx00502", "identifierType"=>"DOI"}, {"identifier"=>"http://www.priorartregister.com/resolve.php?disclosure=OTTX00502", "identifierType"=>"URL"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("Disclosure")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{"name"=>"Anonymous"}])
      expect(subject.titles).to eq([{"title"=>"Messung der Bildunschaerfe in H.264-codierten Bildern und Videosequenzen"}])
      expect(subject.dates).to eq([{"date"=>"07.04.2017", "dateType"=>"Available"}, {"date"=>"2017", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2017")
      expect(subject.publisher).to eq("Siemens AG")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
    end

    it "leading and trailing whitespace" do
      input = "https://doi.org/10.21944/temis-OZONE-MSR2"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.21944/temis-ozone-msr2", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceType"]).to eq("Satellite data")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{"nameType"=>"Personal",
                                       "nameIdentifiers"=>
                                         [{"nameIdentifier"=>"https://orcid.org/0000-0002-0077-5338",
                                           "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}],
                                     "name"=>"Van Der A, Ronald",
                                     "givenName"=>"Ronald",
                                     "familyName"=>"Van Der A",
                                     "affiliation"=>"Royal Netherlands Meteorological Institute (KNMI)"},
                                    {"nameType"=>"Personal",
                                     "name"=>"Allaart, Marc",
                                     "givenName"=>"Marc",
                                     "familyName"=>"Allaart",
                                     "affiliation"=>"Royal Netherlands Meteorological Institute (KNMI)"},
                                    {"nameType"=>"Personal",
                                     "name"=>"Eskes, Henk",
                                     "givenName"=>"Henk",
                                     "familyName"=>"Eskes",
                                     "nameIdentifiers"=> [{"nameIdentifier"=>"https://orcid.org/0000-0002-8743-4455", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}],
                                     "affiliation"=>"Royal Netherlands Meteorological Institute (KNMI)"}])
      expect(subject.titles).to eq([{"title"=>"Multi-Sensor Reanalysis (MSR) of total ozone, version 2"}])
      expect(subject.version_info).to eq("2")
      expect(subject.dates).to eq([{"date"=>"2014-04-25", "dateType"=>"Available"}, {"date"=>"1970-04-01 / (:tba)", "dateType"=>"Collected"}, {"date"=>"2015", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2015")
      expect(subject.publisher).to eq("Royal Netherlands Meteorological Institute (KNMI)")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    end

    it "DOI not found" do
      input = "https://doi.org/10.4124/05F6C379-DD68-4CDB-880D-33D3E9576D52/1"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be false
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.4124/05f6c379-dd68-4cdb-880d-33d3e9576d52/1", "identifierType"=>"DOI"}])
      expect(subject.doi).to eq("10.4124/05f6c379-dd68-4cdb-880d-33d3e9576d52/1")
      expect(subject.agency).to eq("DataCite")
      expect(subject.state).to eq("not_found")
    end

    it "DOI in test system" do
      input = "https://handle.test.datacite.org/10.22002/d1.694"
      subject = Bolognese::Metadata.new(input: input, sandbox: true)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://handle.test.datacite.org/10.22002/d1.694", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.creators).to eq([{"name"=>"Tester"}])
      expect(subject.titles).to eq([{"title"=>"Test license"}])
      expect(subject.dates).to eq([{"date"=>"2018-01-12", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2018")
      expect(subject.publisher).to eq("CaltechDATA")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
      expect(subject.state).to eq("findable")
    end

    it "DOI in test system schema 3" do
      input = "10.21956/wellcomeopenres.25947.r17364"
      subject = Bolognese::Metadata.new(input: input, doi: input, sandbox: true)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://handle.test.datacite.org/10.21956/wellcomeopenres.25947.r17364", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.creators).to eq([{"name"=>"Fran2 Levy"}])
      expect(subject.titles).to eq([{"title"=>"Referee report. For: FL Regression Wellcome [version 1; referees: retracted]"}])
      expect(subject.dates).to eq([{"date"=>"2018", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2018")
      expect(subject.publisher).to eq("F1000 Research Limited")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
      expect(subject.state).to eq("findable")
    end

    it "Referee report in test system" do
      input = "10.21956/gatesopenres.530.r190"
      subject = Bolognese::Metadata.new(input: input, sandbox: true)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://handle.test.datacite.org/10.21956/gatesopenres.530.r190", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("ScholarlyArticle")
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["ris"]).to eq("RPRT")
      expect(subject.types["citeproc"]).to eq("article-journal")
      expect(subject.creators.length).to eq(5)
      expect(subject.creators.first).to eq("nameType"=>"Personal", "name"=>"Patel, Lina", "givenName"=>"Lina", "familyName"=>"Patel")
      expect(subject.titles).to eq([{"title"=>"Referee report. For: Gates - add article keywords to the metatags [version 2; referees: 1 approved]"}])
      expect(subject.publication_year).to eq("2018")
      expect(subject.publisher).to eq("Gates Open Research")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
    end

    it "multiple rights" do
      input = fixture_path + "datacite-multiple-rights.xml"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.rights_list).to eq([{"rights"=>"info:eu-repo/semantics/openAccess"}, {"rights"=>"Open Access", "rightsUri"=>"info:eu-repo/semantics/openAccess"}])
    end

    it "missing creators" do
      input = fixture_path + "datacite_missing_creator.xml"
      subject = Bolognese::Metadata.new(input: input, regenerate: true)
      expect(subject.creators).to be_blank
      expect(subject.valid?).to be false
      expect(subject.errors).to eq("4:0: ERROR: Element '{http://datacite.org/schema/kernel-4}creators': Missing child element(s). Expected is ( {http://datacite.org/schema/kernel-4}creator ).")
    end

    it "malformed creators" do
      input = fixture_path + "datacite_malformed_creator.xml"
      subject = Bolognese::Metadata.new(input: input, regenerate: false)
      expect(subject.creators).to be_blank
      expect(subject.valid?).to be false
      expect(subject.errors).to eq("16:0: ERROR: Element '{http://datacite.org/schema/kernel-4}creatorName': This element is not expected. Expected is ( {http://datacite.org/schema/kernel-4}affiliation ).")
    end

    it "empty funding references" do
      input = fixture_path + "funding_reference.xml"
      subject = Bolognese::Metadata.new(input: input, regenerate: false)
      expect(subject.valid?).to be false
      expect(subject.funding_references).to eq([{"funderName"=>"Agency for Science, Technology and Research (Singapore)"}])
      expect(subject.errors.first).to eq("31:0: ERROR: Element '{http://datacite.org/schema/kernel-4}fundingReference': Missing child element(s). Expected is one of ( {http://datacite.org/schema/kernel-4}funderName, {http://datacite.org/schema/kernel-4}funderIdentifier, {http://datacite.org/schema/kernel-4}awardNumber, {http://datacite.org/schema/kernel-4}awardTitle ).")
    end

    it "dissertation" do
      input = "10.3204/desy-2014-01645"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.3204/desy-2014-01645", "identifierType"=>"DOI"}])
      expect(subject.types["resourceTypeGeneral"]).to eq("Text")
      expect(subject.types["resourceType"]).to eq("Dissertation")
      expect(subject.types["schemaOrg"]).to eq("Thesis")
      expect(subject.types["bibtex"]).to eq("phdthesis")
      expect(subject.types["citeproc"]).to eq("thesis")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "name"=>"Conrad, Heiko", "givenName"=>"Heiko", "familyName"=>"Conrad"}])
      expect(subject.titles).to eq([{"title"=>"Dynamics of colloids in molecular glass forming liquids studied via X-ray photon correlation spectroscopy"}])
      expect(subject.dates).to eq([{"date"=>"2014", "dateType"=>"Issued"},
        {"date"=>"2014", "dateType"=>"Copyrighted"},
        {"date"=>"2009-10-01/2014-01-23", "dateType"=>"Created"}])
      expect(subject.publication_year).to eq("2014")
      expect(subject.publisher).to eq("Deutsches Elektronen-Synchrotron, DESY, Hamburg")
      expect(subject.agency).to eq("DataCite")
      expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-3")
    end

    it "DOI in with related id system" do
      input = "https://doi.org/10.4121/uuid:3926db30-f712-4394-aebc-75976070e91f"
      subject = Bolognese::Metadata.new(input: input)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.4121/uuid:3926db30-f712-4394-aebc-75976070e91f", "identifierType"=>"DOI"}])
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
      expect(subject.titles).to eq([{"title"=>"BPI Challenge 2012"}])
      expect(subject.dates).to eq([{"date"=>"2011-10-01/2012-03-14", "dateInformation"=>"Temporal coverage of this dataset.", "dateType"=>"Other"}, {"date"=>"2012", "dateType"=>"Issued"}])
      expect(subject.publication_year).to eq("2012")
      expect(subject.state).to eq("findable")
    end
  end

  context "change datacite metadata" do
    it "change title" do
      subject.titles = [{"title"=> "A new malaria agent in African hominids." }]
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5061/dryad.8515", "identifierType"=>"DOI"},
        {"identifier"=>
         "Ollomo B, Durand P, Prugnolle F, Douzery EJP, Arnathau C, Nkoghe D, Leroy E, Renaud F (2009) A new malaria agent in African hominids. PLoS Pathogens 5(5): e1000446.",
         "identifierType"=>"citation"}])
      expect(subject.doi).to eq("10.5061/dryad.8515")
      expect(subject.url).to eq("http://datadryad.org/resource/doi:10.5061/dryad.8515")
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.titles).to eq([{"title"=> "A new malaria agent in African hominids." }])
    end

    it "change state" do
      subject.state = "registered"
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5061/dryad.8515", "identifierType"=>"DOI"},
        {"identifier"=>
         "Ollomo B, Durand P, Prugnolle F, Douzery EJP, Arnathau C, Nkoghe D, Leroy E, Renaud F (2009) A new malaria agent in African hominids. PLoS Pathogens 5(5): e1000446.",
         "identifierType"=>"citation"}])
      expect(subject.doi).to eq("10.5061/dryad.8515")
      expect(subject.url).to eq("http://datadryad.org/resource/doi:10.5061/dryad.8515")
      expect(subject.types["schemaOrg"]).to eq("Dataset")
      expect(subject.titles).to eq([{"title"=>"Data from: A new malaria agent in African hominids."}])
      expect(subject.state).to eq("registered")
    end
  end

  context "change datacite metadata on input" do
    it "change doi" do
      input = fixture_path + 'datacite.xml'
      doi = "10.5061/dryad.8515"
      subject = Bolognese::Metadata.new(input: input, doi: doi)
      expect(subject.valid?).to be true
      expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5061/dryad.8515", "identifierType"=>"DOI"},
        {"identifier"=>"MS-49-3632-5083", "identifierType"=>"Local accession number"}])
      expect(subject.doi).to eq("10.5061/dryad.8515")
      expect(subject.creators).to eq([{"nameType"=>"Personal", "nameIdentifiers"=> [{"nameIdentifier"=>"https://orcid.org/0000-0003-1419-2405", "nameIdentifierScheme"=>"ORCID", "schemeUri"=>"https://orcid.org"}], "name"=>"Fenner, Martin", "givenName"=>"Martin", "familyName"=>"Fenner"}])
      expect(subject.titles).to eq([{"title"=>"Eating your own Dog Food"}])
      expect(subject.publisher).to eq("DataCite")
      expect(subject.publication_year).to eq("2016")
    end
  end

  it "GTEx dataset" do
    input = fixture_path + 'gtex.xml'
    url = "https://ors.datacite.org/doi:/10.25491/9hx8-ke93"
    content_url = "https://storage.googleapis.com/gtex_analysis_v7/single_tissue_eqtl_data/GTEx_Analysis_v7_eQTL_expression_matrices.tar.gz"
    subject = Bolognese::Metadata.new(input: input, from: 'datacite', url: url, content_url: content_url)

    expect(subject.valid?).to be true
    expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.25491/9hx8-ke93", "identifierType"=>"DOI"}])
    expect(subject.url).to eq("https://ors.datacite.org/doi:/10.25491/9hx8-ke93")
    expect(subject.content_url).to eq("https://storage.googleapis.com/gtex_analysis_v7/single_tissue_eqtl_data/GTEx_Analysis_v7_eQTL_expression_matrices.tar.gz")
    expect(subject.types["schemaOrg"]).to eq("Dataset")
    expect(subject.types["resourceType"]).to eq("DroNc-seq data")
    expect(subject.creators).to eq([{"name"=>"The GTEx Consortium", "nameType"=>"Organizational"}])
    expect(subject.titles).to eq([{"title"=>"DroNc-seq data"}])
    expect(subject.subjects).to eq([{"subject"=>"gtex"}, {"subject"=>"annotation"}, {"subject"=>"phenotype"}, {"subject"=>"gene regulation"}, {"subject"=>"transcriptomics"}])
    expect(subject.dates).to eq([{"date"=>"2017", "dateType"=>"Issued"}])
    expect(subject.publication_year).to eq("2017")
    expect(subject.related_identifiers.length).to eq(4)
    expect(subject.related_identifiers.last).to eq("relatedIdentifier"=>"https://www.ebi.ac.uk/miriam/main/datatypes/MIR:00000663", "relatedIdentifierType"=>"URL", "relationType"=>"IsPartOf")
    expect(subject.formats).to eq(["application/tar"])
    expect(subject.sizes).to eq(["15.7M"])
    expect(subject.container).to eq("identifier"=>"https://www.ebi.ac.uk/miriam/main/datatypes/MIR:00000663", "identifierType"=>"URL", "title"=>"GTEx", "type"=>"DataRepository")
    expect(subject.publisher).to eq("GTEx")
    expect(subject.funding_references.count).to eq(7)
    expect(subject.funding_references.first).to eq("funderIdentifier"=>"https://doi.org/10.13039/100000052", "funderIdentifierType"=>"Crossref Funder ID", "funderName"=>"Common Fund of the Office of the Director of the NIH")
  end

  it "geo_location_polygon" do
    input = fixture_path + 'datacite-example-polygon-v4.1.xml'
    subject = Bolognese::Metadata.new(input: input)
    expect(subject.identifiers).to eq([{"identifier"=>"https://doi.org/10.5072/example-polygon", "identifierType"=>"DOI"}])
    expect(subject.types["schemaOrg"]).to eq("Dataset")
    expect(subject.types["resourceType"]).to eq("Dataset")
    expect(subject.types["resourceTypeGeneral"]).to eq("Dataset")
    expect(subject.types["ris"]).to eq("DATA")
    expect(subject.types["citeproc"]).to eq("dataset")
    expect(subject.creators.first).to eq("familyName"=>"Den Heijer", "givenName"=>"C", "name"=>"Den Heijer, C", "nameType"=>"Personal")
    expect(subject.titles).to eq([{"lang"=>"en", "title"=>"Meteo measurements at the Sand Motor"}])
    expect(subject.publication_year).to eq("2017")
    expect(subject.publisher).to eq("4TU.Centre for Research Data")
    expect(subject.agency).to eq("DataCite")
    expect(subject.schema_version).to eq("http://datacite.org/schema/kernel-4")
    expect(subject.geo_locations.first["geoLocationPlace"]).to eq("Zandmotor, sand suppletion area on the Dutch coast.")
    expect(subject.geo_locations.first["geoLocationPolygon"].first).to eq("polygonPoint"=>{"pointLatitude"=>"52.03913926329928", "pointLongitude"=>"4.1738852605822"})
  end
end
