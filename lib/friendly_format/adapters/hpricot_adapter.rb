
require 'hpricot'

module FriendlyFormat
  class HpricotAdapter
    class << self

      def parse html
        Hpricot.parse(html)
      end

      def to_html node
        node.to_html
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

      def tag_name node
        node.stag.name
      end

      def tag_begin node
        node.stag.inspect
      end

      def tag_end node
        (node.etag || Hpricot::ETag.new(node.stag.name)).inspect
      end

    end # of class method for HpricotAdapter
  end # of HpricotAdapter
end # of FriendlyFormat
