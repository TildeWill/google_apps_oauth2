module GoogleAppsOauth2
  module Atom
    class Document
      include Node

      def initialize(doc, map = {})
        @doc = parse(doc)
        @map = map
      end

      def parse(xml)
        document = Atom::XML::Document.string(xml)
        Atom::XML::Parser.document(document).parse
      end

      # find_values searches @doc and assigns any values
      # to their corresponding instance variables.  This is
      # useful when we've been given a string of XML and need
      # internal consistency in the object.
      #
      # find_values
      def find_values
        @doc.root.each do |entry|
          intersect = @map.keys & entry.attributes.to_h.keys.map(&:to_sym)
          set_instances(intersect, entry) unless intersect.empty?
        end
      end

      # Sets instance variables in the current object based on
      # values found in the XML document and the mapping specified
      # in GoogleApps::Atom::MAPS

      # @param [Array] intersect
      # @param [LibXML::XML::Node] node
      # @param [Hash] map
      #
      # @visibility public
      # @return
      def set_instances(intersect, node)
        intersect.each do |attribute|
          instance_variable_set "@#{@map[attribute]}", check_value(node.attributes[attribute])
        end
      end
    end
  end
end