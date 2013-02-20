require 'spec_helper'

describe GoogleAppsOauth2::Transport do
  let(:transporter) do
    GoogleAppsOauth2::Transport.new(
        domain: 'cnm.edu',
        token: 'some-token',
        refresh_token: 'refresh_token',
        token_changed_callback: 'callback-proc'
    )
  end

  describe "#get_users" do
    it "Builds a GET request for the user endpoint" do
      stub_request(:get, "https://apps-apis.google.com/a/feeds/cnm.edu/user/2.0?startUsername=znelson1").
          with(:headers => {'Authorization' => 'OAuth some-token', 'Content-Type' => 'application/atom+xml'}).
          to_return(:status => 200, :body => File.read('spec/fixture_xml/users_feed.xml'), :headers => {})

      transporter.get_users(start: 'znelson1', limit: 2)
    end
  end
end