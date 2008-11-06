
module FriendlyFormat
  # reference:
  # http://www.w3.org/TR/1999/REC-html401-19991224/index/elements.html
  class SetCommon < Set
    def initialize
      super([ :a, :area, :b, :big, :blockquote, :br,
              :center, :cite, :code, :del, :div, :em,
              :font, :h1, :h2, :h3, :h4, :h5, :h6, :hr,
              :i, :img, :li, :map, :object, :ol, :p,
              :pre, :small, :span, :strong, :u, :ul     ])
    end
  end
end
