require 'spec_helper'

describe GoogleAppsOauth2::Transport do
  let(:client_secret) { 'sfdfsd087sdf' }
  let(:client_id) { 'blahblahid' }
  let(:transporter) do
    GoogleAppsOauth2::Transport.new(
        domain: 'cnm.edu',
        token: 'some-token',
        refresh_token: 'refresh-token',
        client_id: client_id,
        client_secret: client_secret
    )
  end

  describe "#get_users" do
    it "Builds a GET request for the user endpoint" do
      stub = stub_users_ok(token: 'some-token')

      transporter.get_users(start: 'znelson1', limit: 2)
      stub.should have_been_requested
    end

    it "refreshes the token when the old one expires" do
      stub_users_expired_token(token: 'some-token')
      stub_refresh_token()
      stub_users_ok(token: 'some-new-token')

      transporter.get_users(start: 'znelson1', limit: 2).code.should == 200
    end
  end
end