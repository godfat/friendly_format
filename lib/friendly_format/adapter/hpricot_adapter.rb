
require 'hpricot'

module FriendlyFormat
  module HpricotAdapter
    module_function

    def parse html
      Hpricot.parse(html)
    end

    def to_xhtml node
      node.to_html
    end

    def content node
      node.content
    end

    def text? node
      node.text?
    end

    def element? node
      node.elem?
    end

    def empty? node
      node.empty?
    end

    def attrs node
      node.attributes.inject(''){ |i, (k, v)| i + " #{k}=\"#{v}\"" }
    end

  end # of HpricotAdapter
end # of FriendlyFormat
