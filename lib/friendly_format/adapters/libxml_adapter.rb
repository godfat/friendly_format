
module FriendlyFormat
  class LibxmlAdapter
    class << self

      def parse html
        require 'libxml'
        parser = LibXML::XML::HTMLParser.new
        parser.string = html
        # root is html, children is [body], first is body
        # same as nokogiri
        parser.parse.root.children.first
      end

      def to_html node
        # discard body
        node.children.to_s
      end

      def element? node
        node.element?
      end

      def text? node
        node.text?
      end

      def empty? node
        node.children.empty?
      end

      def tag_name node
        node.name
      end

      def tag_begin node
        "<#{node.name}#{node.attributes.to_h}>"
      end

      def tag_end node
        empty?(node) ? "<#{node.name}/>" : "</#{node.name}>"
      end

    end # of class method for LibxmlAdapter
  end # of LibxmlAdapter
end # of FriendlyFormat
