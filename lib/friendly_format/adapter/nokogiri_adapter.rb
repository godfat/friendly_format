
require 'nokogiri'

module FriendlyFormat
  module NokogiriAdapter
    module_function
    def parse html
      # root is html, children is [body], first is body
      # drop zzz with .children.first since it would wrap a tag p for the article
      Nokogiri::HTML.parse(
        "<zzz>#{html.gsub("\n", '&#xA;')}</zzz>",
        nil, # url?
        html.respond_to?(:encoding) ? html.encoding.name : 'utf-8'
        ).root.children.first.children.first
    end

    def to_xhtml node
      node.to_xhtml
    end

    def content node
      node.to_s
    end

    def empty? node
      node.children.empty?
    end

    def attrs node
      node.attributes.inject(''){ |i, (k, v)| i + " #{k}=\"#{v}\"" }
    end

  end # of NokogiriAdapter
end # of FriendlyFormat
