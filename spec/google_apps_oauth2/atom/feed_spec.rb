require 'spec_helper'

describe GoogleAppsOauth2::Atom::Feed do
  let (:xml) { File.read('spec/fixture_xml/users_feed.xml') }
  let (:next_page) { 'https://apps-apis.google.com/a/feeds/cnm.edu/user/2.0?startUsername=aadams37' }
  let (:feed) { GoogleAppsOauth2::Atom::Feed.new(xml) }
  let (:content_array) { ['<apps:login userId="Mom"/>', '<apps:quota value="80"/>', '<id/>', '<atom:category/>'] }

  describe "#new" do
    it "Parses the given xml" do
      feed.doc.should be_a LibXML::XML::Document
    end

    it "Populates @items with Atom objects of the proper type" do
      feed.items.first.should be_a GoogleAppsOauth2::Atom::User
    end
  end

  describe "#next_page" do
    it "Sets the url for the next page in the feed" do
      feed.next_page.should == next_page
    end
  end

  describe "#entries_from" do
    it "Builds an array of Atom objects" do # We have a bad regex somewhere, User doesn't work as an argument
      results = feed.entries_from document: feed.doc, type: 'user', entry_tag: 'entry'

      results.first.should be_a GoogleAppsOauth2::Atom::User
    end
  end

  describe "#add_category" do
    it "Adds an atom:category node to the front of the content_array" do
      content = feed.add_category(content_array).join("\n")

      content.should include '<atom:category'
      content.should include '#user'
    end
  end

  describe "#entry_wrap" do
    it "Wraps the given content in an apps:entry element" do
      entry = feed.entry_wrap(["bob"]).join("\n")

      entry.should include "<atom:entry xmlns:atom"
      entry.should include "bob"
      entry.should include "</atom:entry>"
    end
  end

  describe "#node_to_ary" do
    it "Returns the content of a node as an array" do
      content = feed.node_to_ary(entry_node)

      content.should be_an Array
    end
  end

  describe "#grab_elements" do
    it "Grabs all elements from the content array matching the filter" do
      matches = feed.grab_elements(content_array, 'apps:')

      matches.each do |match|
        match.should include 'apps:'
      end
    end
  end
end

def entry_node
  entry = LibXML::XML::Node.new 'entry'

  entry << LibXML::XML::Node.new('uncle')
  entry << LibXML::XML::Node.new('aunt')

  entry
end