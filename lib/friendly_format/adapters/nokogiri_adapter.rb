
require 'friendly_format/adapters/libxml_adapter'
require 'nokogiri'

module FriendlyFormat
  class NokogiriAdapter < LibxmlAdapter
    class << self

      def parse html
        # root is html, children is [body], first is body
        # same as libxml
        Nokogiri::HTML.parse("<zzz>#{html}</zzz>").root.children.first.children.first
      end

      def to_xhtml node
        node.to_xhtml
      end

      def tag_begin node
        attrs = node.attributes.map{ |key_value| key_value.join('="') + '"' }.join(' ')
        attrs = ' ' + attrs if attrs != ''
        "<#{node.name}#{attrs}>"
      end

    end # of class method for NokogiriAdapter
  end # of NokogiriAdapter
end # of FriendlyFormat
