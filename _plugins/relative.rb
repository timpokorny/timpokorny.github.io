# Source: https://jclement.ca/2013/12/06/relative_jekyll_paths.html
# Had to modify so it actually dealt with pages that were not nested
#
# To use inside a template, use {{page.relative}} in your template (no slash required at the end)

class Jekyll::Page2

  def relative
    count = url.split("/").length
    if url == "/"
      ""
    elsif url.end_with? "/"  # /about/history/ -- gives us ["","about","history"]
      "../" * (count-1)
    else                     # /about/history.html -- gives us ["","about","history.html"]
      "../" * (count-2)
    end
  end

  def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
    super(attrs + %w[
          relative
    ])

  end
end

class Jekyll::Post2

  def relative

    count = url.split("/").length
    if url == "/"
      ""
    elsif url.end_with? "/"  # /about/history/ -- gives us ["","about","history"]
      "../" * (count-1)
    else                     # /about/history.html -- gives us ["","about","history.html"]
      "../" * (count-2)
    end
  end

  def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
    super(attrs + %w[
          relative
    ])

  end
end
