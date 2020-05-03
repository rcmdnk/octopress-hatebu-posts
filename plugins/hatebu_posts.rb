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
      url = (site.config.key?('hatena_popular_url') and site.config['hatena_popular_url'] != "") ?  site.config['hatena_popular_url'] : site.config['url']
      xml = URI.open("http://b.hatena.ne.jp/entrylist?mode=rss&sort=#{sort}&url=#{url}",
                 {'User-Agent' => 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 '}).read
      doc = REXML::Document.new xml

      html = "<div id='hatena-bookmark-widget'>
  <ul id='hatena_popular_posts' class='posts'>"
      n = 0
      doc.elements.each('rdf:RDF/item') do |i|
        if n >= n_posts
          break
        end
        if n == 2 and site.config['adsense_aside_hatebu']
          html = html + '
  <li>
  <ins class="adsbygoogle"
       style="display:block"
       data-ad-format="fluid"
       data-ad-layout-key="-ho-f+t-8a+ir"
       data-ad-client="ca-pub-' + site.config['adsense_id'].to_s + '"
       data-ad-slot="' + site.config['adsense_aside_hatebu'].to_s + '"></ins>
  <script>
           (adsbygoogle = window.adsbygoogle || []).push({});
  </script>
  </li>'
        end
        count_el = i.elements['hatena:bookmarkcount']
        next if count_el.nil?
        title = i.elements['title'].text.sub(/ - #{site.config['title']}/,"")
        img = i.elements['content:encoded'].text.match(/https?:[\S]+\.(?:jpg|gif|png)/)[0]
        if img == "http://b.hatena.ne.jp/images/append.gif"
          if site.config['sitelogo']
            img = site.config['sitelogo']
          else
            img = nil
          end
        end
        link = i.elements['link'].text
        entry_link = link
        if site.config['hatena_popular_ssl'] != false
          link = link.gsub("http:", "https:")
          if img
            img = img.gsub("http:", "https:")
          end
        end
        imghtml = ''
        if img
          imghtml = "<div class='title-small-thumbnail'>
  <a href='#{link}'><img src='#{img}' alt='#{File.basename(img, ".*")}'></a>
</div>"
        end
        html = html + "
  <li class='post index_click_box'>
    <div class='group'>
      #{imghtml}
      <a href='#{link}' class='click_box_link hatena-bookmark-entrytitle'>#{title}</a>
      <br>
      <img src='//b.hatena.ne.jp/entry/image/#{entry_link}' alt='n_hatebu'>
    </div>
  </li>"
        n = n + 1
      end
      html = html + '
  </ul>
</div>'
      site.config.merge!('hatebu_popular_posts_html' => html)
    end
  end
end
