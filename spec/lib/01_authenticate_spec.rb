require "spec_helper"

describe Modgen::Session do
  it "should not be logged" do
    Modgen::Session.get.should eql(nil)
  end

  it "key cannot be nil" do
    lambda { Modgen::Session.api_key.start }.should raise_error(Modgen::ConfigurationError)
  end

  it "should use Api Key" do
    Modgen.config.api_key.key = 'f0ddaaef2903e6f2ac634e7f6037c9b2'
    Modgen::Session.api_key.start

    lambda { Modgen::Session.api_key.start }.should_not raise_error(Modgen::ConfigurationError)
  end
end
