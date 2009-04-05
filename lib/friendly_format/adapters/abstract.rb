
module FriendlyFormat
  module Abstract

    def method_name node
      # discard body
      node.children.to_s
    end

    def to_xhtml node
      node.to_xhtml
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
      # attrs = node.attributes.map{ |key_value| key_value.join('="') + '"' }.join(' ')
      # attrs = ' ' + attrs if attrs != ''
      # "<#{node.name}#{attrs}>"
      "<#{node.name}>"
    end

    def tag_end node
      "</#{node.name}>"
    end

  end # of Abstract
end # of FriendlyFormat
