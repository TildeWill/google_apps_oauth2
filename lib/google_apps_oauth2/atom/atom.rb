require 'libxml'

module GoogleAppsOauth2
  module Atom
    include LibXML

    NAMESPACES = {
      atom: 'http://www.w3.org/2005/Atom',
      apps: 'http://schemas.google.com/apps/2006',
      gd: 'http://schemas.google.com/g/2005',
      openSearch: 'http://a9.com/-/spec/opensearchrss/1.0/'
    }

    CATEGORY = {
      user: [['scheme', 'http://schemas.google.com/g/2005#kind'], ['term', 'http://schemas.google.com/apps/2006#user']],
    }

    ENTRY_TAG = ["<atom:entry xmlns:atom=\"#{NAMESPACES[:atom]}\" xmlns:apps=\"#{NAMESPACES[:apps]}\" xmlns:gd=\"#{NAMESPACES[:gd]}\">", '</atom:entry>']

    def user(*args)
      User.new *args
    end

    module_function :user
  end
end