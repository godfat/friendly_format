
require 'friendly_format/adapters/abstract'
require 'nokogiri'

module FriendlyFormat
  class NokogiriAdapter
    extend Abstract

    def self.parse html
      # root is html, children is [body], first is body
      # same as libxml
      # drop zzz with .children.first since it would wrap a tag p for the article
      Nokogiri::HTML.parse("<zzz>#{html}</zzz>").root.children.first.children.first
    end

  end # of NokogiriAdapter
end # of FriendlyFormat
