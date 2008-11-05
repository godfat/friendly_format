# encoding: utf-8

require 'rubygems'
require 'minitest/unit'
MiniTest::Unit.autorun

require 'friendly_article'

# 2008-05-09 godfat
class TestXhtmlFormatter < MiniTest::Unit::TestCase
  include FriendlyArticle

  def test_article
    str = 
' http://friends.roodo.com/forum/viewTopic/10170
用 Haskell 寫成的名軟體？

主題發起人 : godfat 真常

2008年04月02日 01:24
第一個當然是首推唐鳳寫的 Pugs!
是基於 Perl 6 一直實作困難，所以才決定寫 Pugs 當中繼者。

Pugs 無論對 Haskell 社群和 Perl 6 社群都有很大的影響。
唐大師：
http://zh.wikipedia.org/wiki/唐鳳

另一個就是 Darcs 了，非常強大的 revision control system,
蠻多人在用的。理所當然，比 svn 先進多了。
svn 其實也差不多是要慢慢式微了...
取而代之的大概會是 SVK, git, 和 Darcs 吧
目前看到是這三個最多，都很先進。不過我對 git 沒好感。

另一方面還有非常多，Haskell 正在成長中啊 ~~~
很多知名 library 都有 haskell binding 了，wxWidgets,
OpenGL, 還有一些 web cgi 之類的東西也有。

現在切入正是時機啊... XD'

    assert_equal \
' <a href="http://friends.roodo.com/forum/viewTopic/10170" title="http://friends.roodo.com/forum/viewTopic/10170">http://friends.roodo.com/forum/viewTopic/10170</a>
用 Haskell 寫成的名軟體？

主題發起人 : godfat 真常

2008年04月02日 01:24
第一個當然是首推唐鳳寫的 Pugs!
是基於 Perl 6 一直實作困難，所以才決定寫 Pugs 當中繼者。

Pugs 無論對 Haskell 社群和 Perl 6 社群都有很大的影響。
唐大師：
<a href="http://zh.wikipedia.org/wiki/" title="http://zh.wikipedia.org/wiki/">http://zh.wikipedia.org/wiki/</a>唐鳳

另一個就是 Darcs 了，非常強大的 revision control system,
蠻多人在用的。理所當然，比 svn 先進多了。
svn 其實也差不多是要慢慢式微了...
取而代之的大概會是 SVK, git, 和 Darcs 吧
目前看到是這三個最多，都很先進。不過我對 git 沒好感。

另一方面還有非常多，Haskell 正在成長中啊 ~~~
很多知名 library 都有 haskell binding 了，wxWidgets,
OpenGL, 還有一些 web cgi 之類的東西也有。

現在切入正是時機啊... XD', s = format_autolink(str)
    assert_equal s, format_autolink_regexp(str)
  end
  def test_persent
    str =
'XDDDD
http://www.amazon.co.jp/%E3%80%8C%E7%84%94~%E3%83%9B%E3%83%A0%E3%83%A9%E3%80%8D~Ar-tonelico2-hymmnos-concert-Side-%E7%B4%85~/dp/B000VKZL30/ref=pd_sbs_sw_img_2 orz'

    assert_equal \
'XDDDD
<a href="http://www.amazon.co.jp/%E3%80%8C%E7%84%94~%E3%83%9B%E3%83%A0%E3%83%A9%E3%80%8D~Ar-tonelico2-hymmnos-concert-Side-%E7%B4%85~/dp/B000VKZL30/ref=pd_sbs_sw_img_2" title="http://www.amazon.co.jp/%E3%80%8C%E7%84%94~%E3%83%9B%E3%83%A0%E3%83%A9%E3%80%8D~Ar-tonelico2-hymmnos-concert-Side-%E7%B4%85~/dp/B000VKZL30/ref=pd_sbs_sw_img_2">http://www.amazon.co.jp/%E3%80%8C%E7%84%94~%E3%...</a> orz', s = format_autolink(str)
    assert_equal s, format_autolink_regexp(str)
  end
  def test_img_src
    str = 
'Thirst for Knowledge
<img src="http://friends.roodo.com/images/diary_photos_large/15386/MjMyNjYtdGhpcnN0X2Zvcl9rbm93bGVkZ2U=.jpg" />

2007年12月14日
'
    assert_equal str, s = format_autolink(str)
    assert_equal s, format_autolink_regexp(str)
  end
  def test_wikipedia_persent
    str = 'http://en.wikipedia.org/wiki/Haskell_%28programming_language%29'
    assert_equal \
'<a href="http://en.wikipedia.org/wiki/Haskell_%28programming_language%29" title="http://en.wikipedia.org/wiki/Haskell_%28programming_language%29">http://en.wikipedia.org/wiki/Haskell_%28program...</a>', s = format_autolink(str)
    assert_equal s, format_autolink_regexp(str)
  end
  def test_wikipedia_parentheses
    str = 'http://en.wikipedia.org/wiki/Haskell_(programming_language)'
    assert_equal \
'<a href="http://en.wikipedia.org/wiki/Haskell_" title="http://en.wikipedia.org/wiki/Haskell_" class="XD">http://en.wikipedia.org/wiki/Haskell_</a>(programming_language)', s = format_autolink(str, :class => 'XD')
    assert_equal s, format_autolink_regexp(str, :class => 'XD')
  end
  def test_fixing_html
    str = 'test<p>if missing end of p'
    assert_equal 'test<p>if missing end of p</p>', format_autolink(str)
    str = 'test<p>if missing<a> end of p'
    assert_equal 'test<p>if missing<a> end of p</a></p>', format_autolink(str)
  end
  def test_www_url
    str = 'go to www.google.com to see if you can see'
    assert_equal 'go to <a href="http://www.google.com" title="http://www.google.com">www.google.com</a> to see if you can see',
      s = format_autolink(str)
    assert_equal s, format_autolink_regexp(str)
  end
  def test_escape_html_and_correct_html
    str = 'test<p>if missing end of p'
    assert_equal 'test<p>if missing end of p</p>', format_article(str, :p)
    assert_equal 'test&lt;p>if missing end of p&lt;/p>', format_article(str, :a)
    str = '<pre>asdasd<a>orz'
    assert_equal '<pre>asdasd&lt;a>orz</pre>', format_article(str, :a, :pre)
    assert_equal '&lt;pre>asdasd<a>orz</a>&lt;/pre>', format_article(str, :a)
    assert_equal '<pre>asdasd&lt;a>orz</pre>', format_article(str, :pre)
    str = 'orz<img>asd'
    assert_equal 'orz<img />asd', format_article(str, :img)
    assert_equal 'orz&lt;img>asd', format_article(str)
  end
  def test_trim_url
    str = 'test with http://8901234567890123456789012345678901234567890.com'

    assert_equal 'test with <a href="http://8901234567890123456789012345678901234567890.com" title="http://8901234567890123456789012345678901234567890.com">http://8901234567890123456789012345678901234567...</a>', s = format_article(str)
    assert_equal s, format_autolink_regexp(str)
  end
  def test_escape_html
    str = 'a lambda expression is &lambda; x. x+1'
    assert_equal str, format_article(str)
    str = 'as you can see, use &lt;img src="asd"/&gt; to use'
    assert_equal str, format_article(str)
  end
  def test_html_with_pre_and_newline2br
    assert_equal File.open('test/sample/complex_article_result.txt').read,
      format_article(File.open('test/sample/complex_article.txt').read, :pre)
  end
  def test_simple_link
    s = '今天是我一歲生日 <a href="http://godfat.org/" title="http://godfat.org/">http://godfat.org/</a> 真的嗎？'
    assert_equal s, format_article(s, :a)
    assert_equal s, format_autolink_regexp(s)
  end
end
