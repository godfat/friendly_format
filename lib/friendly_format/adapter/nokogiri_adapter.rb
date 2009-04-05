
require 'friendly_format/adapter/abstract'
require 'nokogiri'

module FriendlyFormat
  class NokogiriAdapter
    extend Abstract

    def self.parse html
      # root is html, children is [body], first is body
      # same as libxml
      # drop zzz with .children.first since it would wrap a tag p for the article
      Nokogiri::HTML.parse(
        "<zzz>#{html.gsub("\n", '&#xA;')}</zzz>",
        nil, # url?
        html.respond_to?(:encoding) ? html.encoding.name : 'utf-8'
        ).root.children.first.children.first
    end

  end # of NokogiriAdapter
end # of FriendlyFormat
