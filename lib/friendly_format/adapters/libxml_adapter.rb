
require 'friendly_format/adapters/abstract'
require 'libxml'

module FriendlyFormat
  class LibxmlAdapter
    extend Abstract

    def self.parse html
      parser = LibXML::XML::HTMLParser.string(
        "<zzz>#{html}</zzz>",
        :options => LibXML::XML::HTMLParser::Options::RECOVER)

      # root is html, children is [body], first is body
      # same as nokogiri
      # drop zzz with .children.first since it would wrap a tag p for the article
      parser.parse.root.children.first.children.first
    end

    def self.to_xhtml node
      node.to_s
    end

  end # of LibxmlAdapter
end # of FriendlyFormat
