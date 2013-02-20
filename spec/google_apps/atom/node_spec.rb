require 'spec_helper'

describe GoogleAppsOauth2::Atom::Node do
  let (:node_class) { class TestNode < BasicObject; include ::GoogleAppsOauth2::Atom::Node; end }
  let (:node) { node_class.new }
  let (:document) { LibXML::XML::Document.file('spec/fixture_xml/users_feed.xml') }

  describe "#create_node" do
    it "Creates a LibXML::XML::Node with the given attributes" do
      sample = node.create_node type: 'apps:nickname', attrs: [['name', 'Bob']]

      sample.to_s.should include 'apps:nickname name="Bob"'
    end

    it "Creates a Node with multiple attributes" do
      sample = node.create_node type: 'apps:nickname', attrs: [['name', 'Lou'], ['type', 'fake']]

      sample.to_s.should include 'apps:nickname name="Lou" type="fake"'
    end

    it "Creates a LibXML::XML::Node without attributes if none are given" do
      (node.create_node type: 'apps:nickname').to_s.should include 'apps:nickname'
    end
  end

  describe "#add_attributes" do
    it "Adds the specified attributes to the given node" do
      test = LibXML::XML::Node.new 'apps:test'
      node.add_attributes(test, [['name', 'frank'], ['title', 'captain']])

      test.to_s.should include 'name="frank" title="captain"'
    end
  end
end