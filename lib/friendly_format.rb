
require 'set'
require 'friendly_format/set_common'
require 'friendly_format/set_strict'

# 2008-05-09 godfat
module FriendlyFormat
  autoload(:LibxmlAdapter,   'friendly_format/adapter/libxml_adapter')
  autoload(:HpricotAdapter,  'friendly_format/adapter/hpricot_adapter')
  autoload(:NokogiriAdapter, 'friendly_format/adapter/nokogiri_adapter')

  class << self
    attr_writer(:adapter)
    def adapter
      @adapter ||= begin
                     HpricotAdapter
                   rescue LoadError
                     begin
                       NokogiriAdapter
                     rescue LoadError
                       LibxmlAdapter
                     end
                   end
    end
  end

  module_function
  # format entire article for you, passing allowed tags to it.
  # you can use Set or Symbol to specify which tags would be allowed.
  # default was no tags at all, all tags would be escaped.
  # it uses Hpricot to parse input.
  def format_article html, *args
    return html if html.strip == ''

    FriendlyFormat.force_encoding(
      FriendlyFormat.format_article_entrance(html,
        args.inject(Set.new){ |allowed_tags, arg|
          case arg
            when String; allowed_tags << arg
            when Symbol; allowed_tags << arg.to_s
            when Set;    allowed_tags += Set.new(arg.map{|a|a.to_s})
            else; raise(TypeError.new("expected String|Symbol|Set, got #{arg.class}"))
          end
          allowed_tags
        }),
      html)
  end

  # automaticly add "a href" tag on text starts from
  # http/ftp/mailto/etc protocol. use Hpricot to parse and
  # regexp translated from drupal to find where's the target.
  # it uses simplified regexp to do the task. see format_url.
  def format_autolink html, attrs = {}
    return html if html.strip == ''

    FriendlyFormat.force_encoding(
      FriendlyFormat.format_autolink_rec(
        FriendlyFormat.adapter.parse(html), attrs),
      html)
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

  # convert newline character(s) to <br />
  def format_newline text
    # windows: \r\n
    # mac os 9: \r
    text.gsub("\r\n", "\n").tr("\r", "\n").gsub("\n", '<br />')
  end


  # private below

  class << self
    # extract it to public?
    # @api private
    def trim text, length = 75
      # Use +3 for '...' string length.
      if text.size <= 3
        '...'
      elsif text.size > length
        "#{text[0...length-3]}..."
      else
        text
      end
    end

    # same as format_autolink_regexp, but it's simplified and
    # cannot process text composed with html and plain text.
    # used in format_autolink.
    # @api private
    def format_url text, attrs = {}
      # translated from drupal-6.2/modules/filter/filter.module
      # Match absolute URLs.
      text.gsub(
  %r{((http://|https://|ftp://|mailto:|smb://|afp://|file://|gopher://|news://|ssl://|sslv2://|sslv3://|tls://|tcp://|udp://|www\.)([a-zA-Z0-9@:%_+*~#?&=.,/;-]*[a-zA-Z0-9@:%_+*~#&=/;-]))([.,?!]*?)}i){ |match|
        url = $1 # is there any other way to get this variable?
        caption = trim(url)
        html_attrs = attrs.map{ |k,v| " #{k}=\"#{v}\""}.join

        # Match www domains/addresses.
        url = "http://#{url}" unless url =~ %r{^http://}
        "<a href=\"#{url}\" title=\"#{url}\"#{html_attrs}>#{caption}</a>"
      # Match e-mail addresses.
      }.gsub( %r{([A-Za-z0-9._-]+@[A-Za-z0-9._+-]+\.[A-Za-z]{2,4})([.,?!]*?)}i,
              '<a href="mailto:\1">\1</a>')
    end

    # perhaps we should escape all inside code instead of pre?
    # @api private
    def escape_ltgt_inside_pre html, allowed_tags
      return html unless allowed_tags.member?('pre')
      # don't bother nested pre, because we escape all tags in pre
      html = html + '</pre>' unless html =~ %r{</pre>}i
      html.gsub(%r{<pre>(.*)</pre>}mi){
        # stop escaping for '>' because drupal's url filter would make &gt; into url...
        # is there any other way to get matched group?
        "<pre>#{escape_ltgt($1)}</pre>"
      }
    end

    # @api private
    def format_autolink_rec elem, attrs = {}
      elem.children.map{ |e|
        if adapter.text?(e)
          format_url(e.content, attrs)

        elsif adapter.element?(e)
          if adapter.empty?(e)
            adapter.to_xhtml(e)
          else
            "<#{e.name}>" +
            format_autolink_rec(e, attrs) +
            "</#{e.name}>"
          end

        else
          e

        end

      }.join
    end

    # recursion entrance
    # @api private
    def format_article_entrance html, allowed_tags = Set.new
      format_article_rec(
        adapter.parse(escape_ltgt_inside_pre(html, allowed_tags)),
        allowed_tags)
    end

    # recursion
    # @api private
    def format_article_rec elem, allowed_tags = Set.new, no_format_newline = false
      elem.children.map{ |e|
        if adapter.text?(e)
          if no_format_newline
            format_url(adapter.content(e))
          else
            format_newline(format_url(adapter.content(e)))
          end

        elsif adapter.element?(e)
          if allowed_tags.member?(e.name)
            if adapter.empty?(e) || e.name == 'a'
              adapter.to_xhtml(e)
            else
              "<#{e.name}>" +
              format_article_rec(
                e, allowed_tags, e.name == 'pre') +
              "</#{e.name}>"
            end
          else
            if adapter.empty?(e)
              "&lt;#{e.name}&gt;"
            else
              "&lt;#{e.name}&gt;" +
              format_article_rec(e, allowed_tags) +
              "&lt;/#{e.name}&gt;"
            end
          end

        end
      }.join
    end

    # i cannot find a way to escape both lt and gt,
    # so it's a trick that just escape lt and no browser
    # would treat complex lt and gt structure to be a tag
    # wraping content.
    # @api private
    def escape_ltgt text
      text.gsub('<', '&lt;').gsub('>', '&gt;')
    end

    # force encoding for ruby 1.9
    # @api private
    def force_encoding output, input
      if output.respond_to?(:force_encoding)
        output.force_encoding(input.encoding)
      else
        output
      end
    end

  end
end
