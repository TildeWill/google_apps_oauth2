require 'spec_helper'

describe GoogleAppsOauth2::Atom::User do
	let (:gapp) { GoogleAppsOauth2::Atom::User.new(xml) }
	let (:user) { ["test_account", "Test", "Account", "db64e604690686663821888f20373a3941ed7e95", 2048] }
  let (:xml) { File.read('spec/fixture_xml/user.xml') }
  let (:default_password) { 'default' }

	describe '#new' do
		it "creates an xml document matching the given argument" do
      usr = GoogleAppsOauth2::Atom.user xml

      usr.doc.to_s.should include xml
    end
	end

  describe "#find_values" do
    it "Populates instance variables with values from @doc" do
      user = GoogleAppsOauth2::Atom::User.new xml

      user.login.should == 'lholcomb2'
      user.suspended.should == false
      user.first_name.should == 'Lawrence'
      user.last_name.should == 'Holcomb'
    end
  end

  describe "#check_value" do
    it "Returns true if the value is 'true'" do
      gapp.send(:check_value, 'true').should == true
    end

    it "Returns flase if the value is 'false'" do
      gapp.send(:check_value, 'false').should == false
    end

    it "Returns the origional object if not == 'true' or 'false'" do
      gapp.send(:check_value, 'bob').should == 'bob'
    end
  end
end