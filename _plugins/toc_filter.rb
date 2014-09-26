module TocFilter
	def toc_filter( input )
		return "Oh hai there"
 
		#words = input.split.size;
		#minutes = ( words / words_per_minute ).floor
		#minutes_label = minutes === 1 ? " minute" : " minutes"
		#minutes > 0 ? "about #{minutes} #{minutes_label}" : "less than 1 minute"
	end
end
 
Liquid::Template.register_filter(TocFilter)