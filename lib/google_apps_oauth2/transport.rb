require 'cgi'
require 'openssl'
require 'rexml/document'
require 'httparty'

module GoogleAppsOauth2
  class Transport
    include HTTParty

    parser GoogleAppsOauth2::Parsers::FeedParser

    base_uri 'https://apps-apis.google.com/a/feeds'

    def initialize(options)
      @domain = options[:domain]
      @token = options[:token]
      @client_id = options[:client_id]
      @client_secret = options[:client_secret]
      @refresh_token = options[:refresh_token]
      @token_changed_callback = options[:token_changed_callback]

      @user_path= "/#{@domain}/user/2.0"
    end

    def get_users(options = {})
      headers = {'content-type' => 'application/atom+xml', 'Authorization' => "OAuth #{token}"}

      url = user_path + "?startUsername=#{options[:start]}"
      response = self.class.get(url, headers: headers)
      response = check_for_refresh(response)

      response
    end

    private
    attr_reader :user_path
    attr_reader :domain, :token, :refresh_token, :client_id, :client_secret

    def check_for_refresh(old_response)
      response = old_response
      if old_response.code == 401
        data = {
            :client_id => @client_id,
            :client_secret => @client_secret,
            :refresh_token => refresh_token,
            :grant_type => "refresh_token"
        }
        response_json = MultiJson.load(self.class.post("https://accounts.google.com/o/oauth2/token", :body => data))
        @token = response_json["access_token"]
        headers = old_response.request.options[:headers].merge("Authorization" => "OAuth #{token}")
        response = self.class.get(old_response.request.uri.to_s, headers: headers)
      end
      response
    end
  end
end