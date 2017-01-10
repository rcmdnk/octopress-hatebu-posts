# octopress-hatebu-posts
Sidebar module of Hatena-bookmark popular posts list for  Octopress.

## Installation

* Copy **source/_includes/custom/asides/hatebu_posts.html** to **source/_includes/custom/asides/**.
* Copy **sass/plugins/_hatebu-postss.scss** to **sass/plugins/**.
* Copy **plugins/hatebu_posts.rb** to **plugins/**.

And set your configuration in **_config.yml**:

```yaml
# Asides
default_asides:
  - ...
  - ...
  - custom/asides/hatebu_posts.html
  - ...
  - ...

# Hatena Bookmark
hatena_popular_num: 5
hatena_popular_posts: static # orig (Hatena's api), light (Take a list from entrylist, dynamically made by js), feed (Take a list from RSS, with thumbnails, dynamically by js), static (Take a list from RSS, with thumbnails, generated at `rake generate`)
hatena_popular_sort: count # eid (new entries), hot (hot topics), count (order by hatebu counts)
hatena_popular_title: Hatebu Popular Posts
hatena_popular_ssl: true # if link/image in the list should be renamed to https or not
```
