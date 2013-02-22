require 'spec_helper'

module GoogleAppsOauth2
  module Parsers
    describe FeedParser do
      describe '#call' do
        it "returns an array of users" do
          body = File.read('spec/fixture_xml/users_feed.xml')
          users = FeedParser.call(body, :atom)

          users.first.class.should == GoogleAppsOauth2::Atom::User
        end
      end
    end
  end
end