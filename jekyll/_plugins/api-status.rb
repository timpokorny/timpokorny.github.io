#
# Generates a table row suitable for display in a Portico API Status table.
# Given a method name and optional notes, it will break the string down and display
# it such that the notes are in a nice looking tooltip and the method name is bolded
#
# Example:
#   {% supported void connect( FederateAmbassador fedamb, CallbackModel model); Some notes %}
#      -outputs-
#   <tr><td><span class='tooltip label label-success' title='Some notes'>Supported</span></td><td>void <b>connect</b>( ..args.. )</td></tr>
#
# Valid tag types:
#   - {% supported %}
#   - {% notsupported %}
#   - {% partialsupport %}
#
module Jekyll
	class SupportTag < Liquid::Tag
		@tagname = nil
		@notes   = nil
		@method  = nil
		@params  = nil
		@retval  = nil

		def initialize( tag_name, text, tokens )
			#{% supported2 void connect( FederateAmbassador, CallbackModel, String ); Doesn't really work %}
			super
			@tagname = tag_name
			_tokens = text.split(";")
			@method = _tokens.shift.strip
			@notes  = _tokens.shift
			@notes = @notes.strip unless @notes.nil?

			# break the method name down
			_tokens = @method.split(" ")
			@retval = _tokens.shift.strip
			@method = _tokens.join(" ")
			_tokens = @method.split("(")
			@method = _tokens[0]
			@params = "("+_tokens[1]
		end

		def render(context)
			if @tagname == "supported"
				"<tr><td><span class='tooltip label label-success' title='#{@notes}'>Supported</span></td><td>#{@retval} <b>#{@method}</b>#{@params}</td></tr>"	
			elsif @tagname == "notsupported"
				"<tr><td><span class='tooltip label label-danger' title='#{@notes}'>Not Supported</span></td><td>#{@retval} <b>#{@method}</b>#{@params}</td></tr>"	
			elsif @tagname == "partialsupport"	
				"<tr><td><span class='tooltip label label-info' title='#{@notes}'>Partial Support</span></td><td>#{@retval} <b>#{@method}</b>#{@params}</td></tr>"	
			else
				"<tr><td>Error</td><td>Could not determine tag type #{@tagname}</td></tr>"	
			end
		end
	end
end

Liquid::Template.register_tag('supported', Jekyll::SupportTag)
Liquid::Template.register_tag('notsupported', Jekyll::SupportTag)
Liquid::Template.register_tag('partialsupport', Jekyll::SupportTag)
