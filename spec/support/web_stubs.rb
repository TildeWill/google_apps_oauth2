def stub_users_expired_token(options = {})
  stub_request(:get, "https://apps-apis.google.com/a/feeds/cnm.edu/user/2.0?startUsername=znelson1").
      with(:headers => {'Authorization' => "OAuth #{options[:token]}", 'Content-Type' => 'application/atom+xml'}).
      to_return(:status => 401, :body => File.read('spec/fixtures/invalid_token.html'))
end

def stub_refresh_token
  stub_request(:post, "https://accounts.google.com/o/oauth2/token").
      to_return(:status => 200, :body => File.read('spec/fixtures/refreshed_token_response.json'))
end

def stub_users_ok(options = {})
  stub_request(:get, "https://apps-apis.google.com/a/feeds/cnm.edu/user/2.0?startUsername=znelson1").
      with(:headers => {'Authorization' => "OAuth #{options[:token]}", 'Content-Type' => 'application/atom+xml'}).
      to_return(:status => 200, :body => File.read('spec/fixtures/users_feed.xml'))
end