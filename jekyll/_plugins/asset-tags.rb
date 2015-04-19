###############################################################################################
#
#   File Contents
#
#   (tag) page_asset  Get's relative path to a directory of assets for a particular page
#   (tag) site_asset  Get's relative path to a common directory of assets for a site
#   (tag) site_root   Get's relative path to the site root directory
#
###############################################################################################


###############################################################################################
# Title: Page Asset Tag for Jekyll
# Author: Tim Pokorny (adapted from work by Sam Rayner http://samrayner.com)
# Description: Output a relative URL for assets based on the post/page path
# Location: (Tim) TBC
#           (Sam) https://github.com/samrayner/jekyll-asset-path-plugin
#
# Syntax {% page_asset [filename] %}
#
# Examples:
# {% page_asset kitten.png %} on post 2013-01-01-post-title
# {% page_asset pirate.mov %} on page page-title
#
# Output:
# ../../../../../../assets/posts/2013/01/01/post-title/kitten.png  -- assuming pretty permalinks
# assets/pages/page-title/pirate.mov
#
###############################################################################################
module Jekyll
  class PageAssetTag < Liquid::Tag
    @filename = nil

    def initialize(tag_name, markup, tokens)
      #strip leading and trailing quotes
      @filename = markup.strip.gsub(/^("|')|("|')$/, '')
      super
    end

    def render(context)
      if @filename.empty?
        return "Error processing input, expected syntax: {% page_asset [filename] %}"
      end

      path = ""
      page = context.environments.first["page"]

      #if a post
      if page["id"]
        #loop through posts to find match and get slug
        context.registers[:site].posts.each do |post|
          if post.id == page["id"]
            path = "posts#{post.url}"
          end
        end
      else
        path = "pages"+page["url"]  # prefix with "pages" so the asset location is "assets/pages/..."
        
        # remove the file extension for the page so that we get a special directory for
        # all the page's assets. If we don't do this, the whole page is stripped.
        temp = path.split( "." )
        path = temp[0,temp.size-1].join("");
      end

      # get the relative location back to the root - we do this before we strip
      # the filename as our relative function needs this
      relative_root = relative(path)

      # strip filename
      path = File.dirname(path) if path =~ /\.\w+$/

      #fix double slashes
      "#{relative_root}assets/#{path}/#{@filename}".gsub(/\/{2,}/, '/')
    end

  end
end

Liquid::Template.register_tag('page_asset', Jekyll::PageAssetTag)


###############################################################################################
# Title: Site Asset Tag for Jekyll
# Author: Tim Pokorny
# Description: Output a relative URL for general site assets based on the post/page path
# Location: TBC
#
# Syntax {% site_asset some/path/file.ext %}
#
# Examples:
# {% site_asset css/site.css %} on post 2013-01-01-post-title
# {% site_asset css/site.css %} on page /page-title               (without pretty permamlinks)
# {% site_asset css/site.css %} on page /page-title               (with pretty permamlinks)
#
# Output:
# ../../../../../../assets/js/jquery.min.js  -- assuming pretty permalinks
# assets/js/jquery.min.js
# ../assets/js/jquery.min.js
#
###############################################################################################
module Jekyll
  class SiteAssetTag < Liquid::Tag
    @filename = nil

    def initialize(tag_name, markup, tokens)
      #strip leading and trailing quotes
      @filename = markup.strip.gsub(/^("|')|("|')$/, '')
      super
    end

    def render(context)
      if @filename.empty?
        return "Error processing input, expected syntax: {% page_asset [filename] %}"
      end

      path = ""
      page = context.environments.first["page"]

      #if a post
      if page["id"]
        #loop through posts to find match and get slug
        context.registers[:site].posts.each do |post|
          if post.id == page["id"]
            path = post.url
          end
        end
      else
        path = page["url"]  # prefix with "pages" so the asset location is "assets/pages/..."
      end

      # get the relative location back to the root - we do this before we strip
      # the filename as our relative function needs this
      relative_root = relative(path)

      # strip filename
      path = File.dirname(path) if path =~ /\.\w+$/

      # fix double slashes
      "#{relative_root}assets/#{@filename}".gsub(/\/{2,}/, '/')
    end

  end
end

Liquid::Template.register_tag('site_asset', Jekyll::SiteAssetTag)

###############################################################################################
# Title: Relative URL to the site root
# Author: Tim Pokorny
# Description: Output a relative URL to the site root
# Location: TBC
#
# Syntax {% site_root %}
#
# Examples:
# {% site_root %}index.html   on post 2013-01-01-post-title
# {% site_root %}index.html   on page /page-title            (without pretty permamlinks)
# {% site_root %}index.html   on page /page-title            (with pretty permamlinks)
#
# Output:
# ../../../../../../index.html  -- assuming pretty permalinks
# index.html
# ../index.html
#
###############################################################################################
module Jekyll
  class SiteRootTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      path = ""
      page = context.environments.first["page"]

      #if a post
      if page["id"]
        #loop through posts to find match and get slug
        context.registers[:site].posts.each do |post|
          if post.id == page["id"]
            path = post.url
          end
        end
      else
        path = page["url"]
      end

      # get the relative location back to the root
      if path == "/"
        ""
      else
        relative(path)
      end

    end

  end
end

Liquid::Template.register_tag('site_root', Jekyll::SiteRootTag)


#
# Returns the relative path from the given local url path to the site root
#
# Example:
# "/"                     => ""
# "/about/"               => "../"
# "/about/about.html"     => "../"
#
# declare it out here so everything can use it -- is this poor form? probably
def relative(url)
  count = url.split("/").length
  modifier = 2

  if !(url.start_with? "/")  # if it doesn't start with a "/" we won't have an empty first param
    modifier -= 1
  end

  if url.end_with? "/"
    modifier -= 1
  end

  # if the url is just "/" ignore everything!
  url == "/" ? "" : "../" * (count-modifier)
end
