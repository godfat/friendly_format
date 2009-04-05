
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
        # gem 'hpricot', '<0.7'
        if node.respond_to?(:stag)
          node.stag.name
        # gem 'hpricot', '>=0.7'
        else
          node.name
        end
      end

      def tag_begin node
        # gem 'hpricot', '<0.7'
        if node.respond_to?(:stag)
          node.stag.inspect
        # gem 'hpricot', '>=0.7'
        else
          "<#{node.name}>"
        end
      end

      def tag_end node
        # gem 'hpricot', '<0.7'
        if node.respond_to?(:stag)
          (node.etag || Hpricot::ETag.new(node.stag.name)).inspect
        # gem 'hpricot', '>=0.7'
        else
          "</#{node.name}>"
        end
      end

    end # of class method for HpricotAdapter
  end # of HpricotAdapter
end # of FriendlyFormat
