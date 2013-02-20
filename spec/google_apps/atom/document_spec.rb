require 'spec_helper'

describe GoogleAppsOauth2::Atom::Document do
  let (:document) { GoogleAppsOauth2::Atom::Document.new File.read('spec/fixture_xml/user.xml') }
  let (:doc_string) { File.read('spec/fixture_xml/users_feed.xml') }

  describe "#parse" do
    it "parses the given XML document" do
      document.parse(doc_string).should be_a LibXML::XML::Document
    end
  end

  describe "#to_s" do
    it "Outputs @doc as a string" do
      document.to_s.should be_a String
    end
  end
end