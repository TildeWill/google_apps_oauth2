module GoogleAppsOauth2
	module Atom
  	class User < Document
      attr_reader :doc, :login, :suspended, :first_name, :last_name, :quota, :password

      MAP = {
        userName: :login,
        suspended: :suspended,
        familyName: :last_name,
        givenName: :first_name,
        limit: :quota,
        password: :password
      }

  		def initialize(xml)
        super(xml, MAP)
        find_values
  		end
  	end
  end
end