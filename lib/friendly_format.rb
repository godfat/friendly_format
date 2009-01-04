
require 'set'
require 'friendly_format/set_common'
require 'friendly_format/set_strict'

# 2008-05-09 godfat
module FriendlyFormat
  autoload(:LibxmlAdapter,   'friendly_format/adapters/libxml_adapter')
  autoload(:HpricotAdapter,  'friendly_format/adapters/hpricot_adapter')
  autoload(:NokogiriAdapter, 'friendly_format/adapters/nokogiri_adapter')

  class << self
    attr_writer(:adapter)
    def adapter
      @adapter ||= HpricotAdapter
    end
  end

  module_function
  # format entire article for you, passing allowed tags to it.
  # you can use Set or Symbol to specify which tags would be allowed.
  # default was no tags at all, all tags would be escaped.
  # it uses Hpricot to parse input.
  def format_article html, *args
    FriendlyFormat.format_article_entrance(html,
      args.inject(Set.new){ |allowed_tags, arg|
        case arg
          when Symbol; allowed_tags << arg
          when Set;    allowed_tags += arg
          else; raise(TypeError.new("expected Symbol or Set, got #{arg.class}"))
        end
        allowed_tags
      })
  end

  # automaticly add "a href" tag on text starts from
  # http/ftp/mailto/etc protocol. use Hpricot to parse and
  # regexp translated from drupal to find where's the target.
  # it uses simplified regexp to do the task. see format_url.
  def format_autolink html, attrs = {}
    doc = FriendlyFormat.adapter.parse(html)
    doc.children.each{ |c|
      next unless FriendlyFormat.adapter.text?(c)
      c.content = format_url(c.content, attrs)
    }
    FriendlyFormat.adapter.to_html(doc)
  end

  # translated from drupal-6.2/modules/filter/filter.module
  # same as format_autolink, but doesn't use Hpricot,
  # use only regexp.
  def format_autolink_regexp text, attrs = {}
    attrs = attrs.map{ |k,v| " #{k}=\"#{v}\""}.join
    # Match absolute URLs.
    " #{text}".gsub(%r{(<p>|<li>|<br\s*/?>|[ \n\r\t\(])((http://|https://|ftp://|mailto:|smb://|afp://|file://|gopher://|news://|ssl://|sslv2://|sslv3://|tls://|tcp://|udp://)([a-zA-Z0-9@:%_+*~#?&=.,/;-]*[a-zA-Z0-9@:%_+*~#&=/;-]))([.,?!]*?)(?=(</p>|</li>|<br\s*/?>|[ \n\r\t\)])?)}i){ |match|
      match = [match, $1, $2, $3, $4, $5]
      match[2] = match[2] # escape something here
      caption = FriendlyFormat.trim match[2]
      # match[2] = sanitize match[2]
      match[1]+'<a href="'+match[2]+'" title="'+match[2]+"\"#{attrs}>"+
        caption+'</a>'+match[5]

    # Match e-mail addresses.
    }.gsub(%r{(<p>|<li>|<br\s*/?>|[ \n\r\t\(])([A-Za-z0-9._-]+@[A-Za-z0-9._+-]+\.[A-Za-z]{2,4})([.,?!]*?)(?=(</p>|</li>|<br\s*/?>|[ \n\r\t\)]))}i, '\1<a href="mailto:\2">\2</a>\3').

    # Match www domains/addresses.
    gsub(%r{(<p>|<li>|[ \n\r\t\(])(www\.[a-zA-Z0-9@:%_+*~#?&=.,/;-]*[a-zA-Z0-9@:%_+~#\&=/;-])([.,?!]*?)(?=(</p>|</li>|<br\s*/?>|[ \n\r\t\)]))}i){ |match|
      match = [match, $1, $2, $3, $4, $5]
      match[2] = match[2] # escape something here
      caption = FriendlyFormat.trim match[2]
      # match[2] = sanitize match[2]
      match[1]+'<a href="http://'+match[2]+'" title="http://'+match[2]+"\"#{attrs}>"+
        caption+'</a>'+match[3]
    }[1..-1]
  end

  # same as format_autolink_regexp, but it's simplified and
  # cannot process text composed with html and plain text.
  # used in format_autolink.
  def format_url text, attrs = {}
    # translated from drupal-6.2/modules/filter/filter.module
    # Match absolute URLs.
    text.gsub(
%r{((http://|https://|ftp://|mailto:|smb://|afp://|file://|gopher://|news://|ssl://|sslv2://|sslv3://|tls://|tcp://|udp://|www\.)([a-zA-Z0-9@:%_+*~#?&=.,/;-]*[a-zA-Z0-9@:%_+*~#&=/;-]))([.,?!]*?)}i){ |match|
      url = $1 # is there any other way to get this variable?

      caption = FriendlyFormat.trim url
      attrs = attrs.map{ |k,v| " #{k}=\"#{v}\""}.join

      # Match www domains/addresses.
      url = "http://#{url}" unless url =~ %r{^http://}
      "<a href=\"#{url}\" title=\"#{url}\"#{attrs}>#{caption}</a>"
    # Match e-mail addresses.
    }.gsub( %r{([A-Za-z0-9._-]+@[A-Za-z0-9._+-]+\.[A-Za-z]{2,4})([.,?!]*?)}i,
            '<a href="mailto:\1">\1</a>')
  end

  # convert newline character(s) to <br />
  def format_newline text
    # windows: \r\n
    # mac os 9: \r
    text.gsub("\r\n", "\n").tr("\r", "\n").gsub("\n", '<br />')
  end

  private
  # extract it to public?
  def self.trim text, length = 75
    # Use +3 for '...' string length.
    if text.size <= 3
      '...'
    elsif text.size > length
      "#{text[0...length-3]}..."
    else
      text
    end
  end

  # perhaps we should escape all inside code instead of pre?
  def self.escape_all_inside_pre html, allowed_tags
    return html unless allowed_tags.member? :pre
    # don't bother nested pre, because we escape all tags in pre
    html = html + '</pre>' unless html =~ %r{</pre>}i
    html.gsub(%r{<pre>(.*)</pre>}mi){
      # stop escaping for '>' because drupal's url filter would make &gt; into url...
      # is there any other way to get matched group?
      "<pre>#{FriendlyFormat.escape_lt(FriendlyFormat.escape_amp($1))}</pre>"
    }
  end

  # recursion entrance
  def self.format_article_entrance html, allowed_tags = Set.new
    FriendlyFormat.format_article_elems(FriendlyFormat.adapter.parse(
      FriendlyFormat.escape_all_inside_pre(html, allowed_tags)), allowed_tags)
  end

  # recursion
  def self.format_article_elems elems, allowed_tags = Set.new, no_format_newline = false
    elems.children.map{ |e|
      if FriendlyFormat.adapter.text?(e)
        if no_format_newline
          format_url(e.content)
        else
          format_newline format_url(e.content)
        end

      elsif FriendlyFormat.adapter.element?(e)
        if allowed_tags.member?(e.name.to_sym)
          if FriendlyFormat.adapter.empty?(e) || e.name == 'a'
            e.to_html
          else
            FriendlyFormat.adapter.tag_begin(e) +
            FriendlyFormat.format_article_elems(
              e, allowed_tags, FriendlyFormat.adapter.tag_name(e) == 'pre') +
            FriendlyFormat.adapter.tag_end(e)
          end
        else
          if FriendlyFormat.adapter.empty?(e)
            FriendlyFormat.escape_lt(FriendlyFormat.adapter.tag_begin(e))
          else
            FriendlyFormat.escape_lt(FriendlyFormat.adapter.tag_begin(e)) +
            FriendlyFormat.format_article_elems(e, allowed_tags) +
            FriendlyFormat.escape_lt(FriendlyFormat.adapter.tag_end(e))
          end
        end

      end
    }.join
  end

  def self.escape_amp text
    text.gsub('&', '&amp;')
  end

  # i cannot find a way to escape both lt and gt,
  # so it's a trick that just escape lt and no browser
  # would treat complex lt and gt structure to be a tag
  # wraping content.
  def self.escape_lt text
    text.gsub('<', '&lt;')
  end

end
