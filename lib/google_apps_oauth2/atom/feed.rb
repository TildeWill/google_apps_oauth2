module GoogleAppsOauth2
  module Atom
    class Feed < Document
      attr_reader :doc, :items, :next_page
      def initialize(body)
        super(body)

        @items = entries_from(document: @doc, entry_tag: 'entry')
      end

      def entries_from(properties)
        properties[:document].root.inject([]) do |results, entry|
          if entry.name == properties[:entry_tag]
            results << new_doc(node_to_ary(entry), ['apps:', 'atom:', 'gd:'])
          end
          set_next_page(entry) if entry.name == 'link' and entry.attributes[:rel] == 'next'
          results
        end
      end

      def set_next_page(node)
        @next_page = node.attributes[:href]
      end

      # node_to_ary converts a Atom::XML::Node to an array.
      #
      # node_to_ary node
      #
      # node_to_ary returns the string representation of the
      # given node split on \n.
      def node_to_ary(node)
        node.to_s.split("\n")
      end

      # new_doc creates a new Atom document from the data
      # provided in the feed.  new_doc takes a type, an
      # array of content to be placed into the document
      # as well as an array of filters.
      #
      # new_doc 'user', content_array, ['apps:']
      #
      # new_doc returns an GoogleApps::Atom document of the
      # specified type.
      def new_doc(content_array, filters)
        content_array = filters.map do |filter|
          grab_elements(content_array, filter)
        end

        add_category(content_array)

        Atom.send :user, entry_wrap(content_array.flatten).join("\n")
      end

      # add_category adds the proper atom:category node to the
      # content_array
      #
      # add_category content_array, 'user'
      #
      # add_category returns the modified content_array
      def add_category(content_array)
        content_array.unshift(create_node(type: 'atom:category', attrs: Atom::CATEGORY[:user]).to_s)
      end

      # grab_elements applies the specified filter to the
      # provided array.  Google's feed provides a lot of data
      # that we don't need in an entry document.
      #
      # grab_elements content_array, 'apps:'
      #
      # grab_elements returns an array of items from content_array
      # that match the given filter.
      def grab_elements(content_array, filter)
        content_array.grep(Regexp.new filter)
      end

      # entry_wrap adds atom:entry opening and closing tags
      # to the provided content_array and the beginning and
      # end.
      #
      # entry_wrap content_array
      #
      # entry_wrap returns an array with an opening atom:entry
      # element prepended to the front and a closing atom:entry
      # tag appended to the end.
      def entry_wrap(content_array)
        content_array.unshift(Atom::ENTRY_TAG[0]).push(Atom::ENTRY_TAG[1])
      end
    end
  end
end