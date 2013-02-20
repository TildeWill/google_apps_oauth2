require 'httparty'

module GoogleAppsOauth2
  module Parsers
    class FeedParser < HTTParty::Parser
      SupportedFormats = {"application/atom+xml" => :atom}

      protected

      def atom
        GoogleAppsOauth2::Atom::Feed.new(body).items
      end
    end
  end
end