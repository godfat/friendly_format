
module FriendlyForamt
  class SetStrict < Set
    def initialize
      super([ :a, :b, :code, :del, :em, :font,
              :i, :img, :li, :ol, :strong, :u, :ul ])
    end
  end
end
