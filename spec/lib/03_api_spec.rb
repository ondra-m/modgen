require "spec_helper"

describe Modgen::API do
  before(:all) do
    Modgen.config.api_key.key = 'f0ddaaef2903e6f2ac634e7f6037c9b2'
    Modgen::Session.api_key.start

    @user = Modgen::API.profile.get.body
  end

  let(:profile) { Modgen::API.profile }
  let(:dataset) { Modgen::API.dataset }

  context "profile" do
    it "get" do
      result = profile.get

      result.status.should eql(200)

      result.body["id"].should          eql(@user["id"])
      result.body["first_name"].should  eql(@user["first_name"])
      result.body["last_name"].should   eql(@user["last_name"])
      result.body["email"].should       eql(@user["email"])
      result.body["created_at"].should  eql(@user["created_at"])
      result.body["updated_at"].should  eql(@user["updated_at"])
      result.body["last_access"].should eql(@user["last_access"])
    end

    context "update" do
      it "should update" do
        result = profile.update(user: { first_name: "a",
                                        last_name: "a",
                                        email: "a@a.aa" })

        result.status.should eql(200)

        result.body["id"].should          eql(@user["id"])
        result.body["first_name"].should  eql("a")
        result.body["last_name"].should   eql("a")
        result.body["email"].should       eql("a@a.aa")
      end

      it "missing value" do
        lambda { profile.update(first_name: "a") }.should raise_error(Modgen::APIRequestError)
      end

      it "wrong format" do
        lambda { profile.update(user: {first_name: "."}) }.should raise_error(Modgen::APIRequestError)
      end
    end
  end

  context "dataset" do
    it "list" do
      result = dataset.list

      result.status.should eql(200)

      result.body['datasets'].size.should eql(3)
    end

    context "get" do
      it "should get" do
        result = dataset.get(id: 1)

        result.status.should eql(200)

        result.body['id'].should eql(1)
      end

      it "missing value" do
        lambda { dataset.get }.should raise_error(Modgen::APIRequestError)
      end

      it "non exist id" do
        result = dataset.get(id: 6)

        result.status.should eql(404)
      end

      it "unknow parameteres" do
        lambda { dataset.get(a: "a") }.should raise_error(Modgen::APIRequestError)
      end
    end
  end
end
