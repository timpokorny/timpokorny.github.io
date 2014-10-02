##
# Monkey patch Jekyll's Page and Post classes.
class Jekyll::Page

	def ancestors
		get_pages(self.url)
	end

	##
	# Make ancestors available.
	def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
		super(attrs + %w[
			ancestors
		])
	end
end

class Jekyll::Post
	def ancestors
		get_pages(self.url)
	end

	##
	# Make ancestors available.
	def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
		super(attrs + %w[
			ancestors
		])
	end
end

##
# Returns ordered list 
def get_pages(url)
	ancestors = []

	while url != "/index.html"
		part = url.split("/")
		if part[-1] != "index.html"
			# to to directory index
			part[-1] = "index.html"
			url = part.join("/")
		else
			# one level up
			url = part[0..-3].join("/") + "/index.html"
		end

		located_page = get_page_from_url( url )
		if located_page
			ancestors << located_page
		end
	end

	ancestors.reverse

end

##
# Gets Page object that has given url. Very inefficient O(n) solution.
def get_page_from_url(url)
	(site.pages + site.posts).each do |page|
		return page if page.url == url
	end

	return nil
end
