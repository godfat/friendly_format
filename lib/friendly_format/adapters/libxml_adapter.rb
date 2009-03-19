
require 'libxml'

module FriendlyFormat
  class LibxmlAdapter
    class << self

      def parse html
        parser = LibXML::XML::HTMLParser.string(
          "<zzz>#{html}</zzz>",
          :options => LibXML::XML::HTMLParser::Options::RECOVER)

        # root is html, children is [body], first is body
        # same as nokogiri
        # drop zzz with .children.first since it would wrap a tag p for the article
        parser.parse.root.children.first.children.first
      end

      def method_name node
        # discard body
        node.children.to_s
      end

      def to_xhtml node
        node.to_s
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
        "<#{node.name}>"
      end

      def tag_end node
        "</#{node.name}>"
      end

    end # of class method for LibxmlAdapter
  end # of LibxmlAdapter
end # of FriendlyFormat
