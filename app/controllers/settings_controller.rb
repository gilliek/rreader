include OpmlParser

class SettingsController < ApplicationController
	def import_export
		respond_to do |format|
			format.html { render :layout => false }
		end
	end

	def do_import
		opml_file = params[:file]
		outlines = OpmlParser::import(opml_file.read)
		@stream_with_error = nil

		outlines.each do |outline|
			stream = RssStream.new
			stream.title = outline.attributes[:title]
			stream.url = outline.attributes[:xmlUrl]
			if !stream.save
				@stream_with_error = stream
				break
			end
		end

		respond_to do |format|
			format.js
		end
	end

	def do_export
	end
end
