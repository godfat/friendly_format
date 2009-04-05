
require 'hpricot'

module FriendlyFormat
  class HpricotAdapter
    class << self

      def parse html
        Hpricot.parse(html)
      end

      def to_xhtml node
        node.to_html
      end

      def content node
        node.content
      end

      def element? node
        node.kind_of?(Hpricot::Elem)
      end

      def text? node
        node.kind_of?(Hpricot::Text)
      end

      def empty? node
        node.empty?
      end

    end # of class method for HpricotAdapter
  end # of HpricotAdapter
end # of FriendlyFormat
