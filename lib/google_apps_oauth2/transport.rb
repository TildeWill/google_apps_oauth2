require 'cgi'
require 'openssl'
require 'rexml/document'
require 'httparty'

module GoogleAppsOauth2
  class Transport
    include HTTParty

    parser GoogleAppsOauth2::Parsers::FeedParser

    attr_reader :domain, :token

    base_uri 'https://apps-apis.google.com/a/feeds'

    def initialize(options)
      @domain = options[:domain]
      @token = options[:token]
      @refresh_token = options[:refresh_token]
      @token_changed_callback = options[:token_changed_callback]

      @user_path= "/#{@domain}/user/2.0"
    end

    def get_users(options = {})
      #limit = options[:limit] || 1000000
      #response = get(user + "?startUsername=#{options[:start]}")
      headers = {'content-type' =>'application/atom+xml', 'Authorization' => "OAuth #{token}"}

      self.class.get(user_path + "?startUsername=#{options[:start]}", headers: headers)
      #pages = fetch_pages(response, limit, :feed)
      #
      #return_all(pages)
    end

    private
    attr_reader :user_path

    def create_doc(response_body, type = nil)
      @doc_handler.create_doc(response_body, type)
    end

    def return_all(pages)
      pages.map do |page|
        page.items
      end
    end

    def get_next_page(next_page_url, type)
      response = get(next_page_url)
      process_response(response)
      GoogleApps::Atom.feed(response.body)
    end

    def fetch_pages(response, limit, type)
      pages = [GoogleApps::Atom.feed(response.body)]

      while (pages.last.next_page) and (pages.count * PAGE_SIZE[:user] < limit)
        pages << get_next_page(pages.last.next_page, type)
      end
      pages
    end

    def singularize(type)
      type.to_s.gsub(/s$/, '')
    end
  end
end