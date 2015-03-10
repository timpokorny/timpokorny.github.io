# Outputs a supported/not supported table row that can slot in to one of the
# tables on the API Status page
 
# e.g. <tr><td>methodCall()</td><td><span class="label label-success">Supported</span></td><td>Notes</td>
# Usage: {% supported text to put in place %}

# Supported Tag
module Jekyll
	class SupportedTag < Liquid::Tag
		@methodname = nil
		@notes = nil

		def initialize( tag_name, text, tokens )
			@methodname = text
			super
		end

		def render(context)
			#"<tr><td>#{@methodname}</td><td><span class='tooltip label label-success' title='#{@notes}'>Supported</span></td></tr>"	
			"<tr><td><span class='tooltip label label-success' title='#{@notes}'>Supported</span></td><td>#{@methodname}</td></tr>"	
		end
	end
end

Liquid::Template.register_tag('supported', Jekyll::SupportedTag)

# Not Supported Tag
module Jekyll
	class NotSupportedTag < Liquid::Tag
		@methodname = nil
		@notes = nil

		def initialize( tag_name, text, tokens )
			@methodname = text
			super
		end

		def render(context)
			#"<tr><td>#{@methodname}</td><td><span class='tooltip label label-danger' title='#{@notes}'>Not Supported</span></td></tr>"	
			"<tr><td><span class='tooltip label label-danger' title='#{@notes}'>Not Supported</span></td><td>#{@methodname}</td></tr>"	
		end
	end
end

Liquid::Template.register_tag('notsupported', Jekyll::NotSupportedTag)

# Partially Supported Tag
module Jekyll
	class PartiallySupportedTag < Liquid::Tag
		@methodname = nil
		@notes = nil

		def initialize( tag_name, text, tokens )
			@methodname = text
			super
		end

		def render(context)
			#"<tr><td>#{@methodname}</td><td><span class='tooltip label label-danger' title='#{@notes}'>Not Supported</span></td></tr>"	
			"<tr><td><span class='tooltip label label-info' title='#{@notes}'>Partial Support</span></td><td>#{@methodname}</td></tr>"	
		end
	end
end

Liquid::Template.register_tag('partialsupport', Jekyll::PartiallySupportedTag)
