
module FriendlyFormat
  # only allow a few tags that won't affect too many layouts.
  # use this in forum or somewhere many people have permissions
  # to post or edit articles.
  class SetStrict < Set
    def initialize
      super(%w[ a b code del em font
                i img li ol strong u ul ])
    end
  end
end
