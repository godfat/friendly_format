
require 'friendly_format/adapters/libxml_adapter'
require 'nokogiri'

module FriendlyFormat
  class NokogiriAdapter < LibxmlAdapter
    class << self

      def parse html
        # root is html, children is [body], first is body
        # same as libxml
        Nokogiri::HTML.parse(html).root.children.first
      end

      def element? node
        node.kind_of?(Nokogiri::XML::Element)
      end

      def text? node
        node.kind_of?(Nokogiri::XML::Text)
      end

      def tag_begin node
        attrs = node.attributes.map{ |key_value| key_value.join('="') + '"' }.join(' ')
        attrs = ' ' + attrs if attrs != ''
        "<#{node.name}#{attrs}>"
      end

    end # of class method for NokogiriAdapter
  end # of NokogiriAdapter
end # of FriendlyFormat
