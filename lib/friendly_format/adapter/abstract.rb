
module FriendlyFormat
  module Abstract

    def method_name node
      # discard body
      node.children.to_s
    end

    def to_xhtml node
      node.to_xhtml
    end

    def content node
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

  end # of Abstract
end # of FriendlyFormat
