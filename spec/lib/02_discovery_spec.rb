# encoding: utf-8

require "spec_helper"

describe Modgen::Discovery do
  before(:all) {
    Modgen.configure do
      api do
        base_url "#{API_URL}/api/"
      end
    end
  }

  let(:config)    { Modgen.config }
  let(:api)       { Modgen::API.api }
  let(:discovery) { Modgen::Discovery }

  context "configure" do
    it "api_base_url should be localhost" do
      config.api.base_url.should eql("#{API_URL}/api/")
    end

    it "api_discovery_versions_url shoud be base_url + versions" do
      config.api.discovery_versions_url.to_s.should eql("#{API_URL}/api/discovery/versions")
    end

    it "api_discovery_version_url shoud be base_url + version/:id" do
      config.api.discovery_version_url.to_s.should eql("#{API_URL}/api/discovery/version/:id")
    end
  end

  context "API detils" do
    it "should show preffered version" do
      discovery.preffered_version.should eql('v1')
    end

    it "should show 2 version" do
      versions = discovery.versions

      versions.status.should eql(200)

      versions.body['versions'].size.should eql(2)
    end

    it "non exist version" do
      lambda { discovery.version('v3') }.should raise_error(Modgen::APIError)
    end

    it "version should take preffered version" do
      discovery.version.body['version'].should eql('v1')
    end

    it "verion should have some values" do
      result = discovery.version('v1').body

      result['name'].should       eql('Modgen API')
      result['version'].should    eql('v1')
      result['created_at'].should eql('16022013')
      result['updated_at'].should eql('16022013')
      result['base_url'].should   eql('https://modgen.net/api')
    end
  end

  context "before discover" do
    it "shoud raise Modgen::APIError" do
      lambda { api }.should raise_error(Modgen::APIError)
    end

    it "should false" do
      Modgen::API.discovered?.should eql(false)
    end
  end

  context "discover" do
    before(:all) {
      Modgen::Discovery.discover('v1')
    }

    it "details about API" do
      api.name.should        eql('Modgen API')
      api.description.should eql('Predikační platforma')
      api.version.should     eql('v1')
      api.created_at.should  eql('16022013')
      api.updated_at.should  eql('16022013')
      api.base_url.should    eql('https://modgen.net/api')
    end

    it "should true" do
      Modgen::API.discovered?.should eql(true)
    end

    it "some methods should exist" do
      Modgen::API.methods.should eql([:profile, :dataset])
      Modgen::API.profile.methods.should eql([:get, :update])
      Modgen::API.dataset.methods.should eql([:list, :get])
    end
  end

end
