
puts '[WARN] [DEPRECATED] hpricot backend for friendly_foramt is deprecated, and would be removed in version 0.8+'

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

    def empty? node
      node.empty?
    end

  end # of HpricotAdapter
end # of FriendlyFormat
