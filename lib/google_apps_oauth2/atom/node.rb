module GoogleAppsOauth2
  module Atom
    module Node

      # create_node takes a hash of properties from which to
      # build the XML node.  The properties hash must have
      # a :type key, it is also possible to pass an :attrs
      # key with an array of attribute name, value pairs.
      #
      # create_node type: 'apps:property', attrs: [['name', 'Tim'], ['userName', 'tim@bob.com']]
      #
      # create_node returns an Atom::XML::Node with the specified
      # properties.
      def create_node(properties)
        if properties[:attrs]
          add_attributes Atom::XML::Node.new(properties[:type]), properties[:attrs]
        else
          Atom::XML::Node.new properties[:type]
        end
      end


      # add_attributes adds the specified attributes to the
      # given node.  It takes a LibXML::XML::Node and an
      # array of name, value attribute pairs.
      #
      # add_attribute node, [['title', 'emperor'], ['name', 'Napoleon']]
      #
      # add_attribute returns the modified node.
      def add_attributes(node, attributes)
        attributes.each do |attribute|
          node.attributes[attribute[0]] = attribute[1]
        end

        node
      end

      # Returns true if "true" and false if "false"

      #
      # @param [String] value
      #
      # @visibility public
      # @return
      def check_value(value)
        case value
          when 'true'
            true
          when 'false'
            false
          else
            value
        end
      end
    end
  end
end