require 'open-uri'
require 'rexml/document'

module Jekyll
  class HatebuPostsGenerator < Generator
    safe :true
    priority :lower

    # Get Hatebu post list

    def generate(site)
      n_posts = site.config['hatena_popular_num'] || 5
      return if n_posts == 0

      sort = (site.config['hatena_popular_sort']) || 'count'
      xml = open("http://b.hatena.ne.jp/entrylist?mode=rss&sort=#{sort}&url=#{site.config['url']}",
                 {'User-Agent' => 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 '}).read
      doc = REXML::Document.new xml

      html = "<div id='hatena-bookmark-widget'><div>
  <ul id='hatena_popular_posts' class='posts'>"
      n = 0
      doc.elements.each('rdf:RDF/item') do |i|
        if n >= n_posts
          break
        end
        title = i.elements['title'].text.sub(/ - #{site.config['title']}/,"")
        link = i.elements['link'].text
        count = i.elements['hatena:bookmarkcount'].text
        img = i.elements['content:encoded'].text.match(/(http:){1}[\S_-]+\.(?:jpg|gif|png)/)[0]
        html = html + "
  <li class='post index_click_box'>
    <div class='group'>
      <div class='title-small-thumbnail'>
        <a href='#{link}'><img src='#{img}'></a>
      </div>
      <a href='#{link}' class='click_box_link hatena-bookmark-entrytitle'>#{title}</a>
      <br>
      <img src='//b.hatena.ne.jp/entry/image/#{link}'>
    </div>
  </li>"
      #<a href='http://b.hatena.ne.jp/entry/#{link}'><img src='//b.hatena.ne.jp/entry/image/#{link}'></a>

        n = n + 1
      end
      html = html + '
  </ul>
</div>'
      site.config.merge!('hatebu_popular_posts_html' => html)
    end
  end
end
