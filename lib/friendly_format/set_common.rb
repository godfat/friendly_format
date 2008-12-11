
module FriendlyFormat
  # reference:
  # http://www.w3.org/TR/1999/REC-html401-19991224/index/elements.html
  # allow most tags to use, use it in weblog or somewhere only
  # a few people have permission to post or edit.
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
