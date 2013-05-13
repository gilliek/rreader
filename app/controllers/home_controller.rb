class HomeController < ApplicationController
  # GET
  def index
    urls = RssStream.select("rss_streams.url").all.map { |v| v[:url] }
    RssStream.update_all_feeds(urls)

    @entries = FeedEntry.order("created_at DESC").limit(20)

    respond_to do |format|
      format.html
      format.json { render json: @entries }
      format.js { render 'rss_streams/show', :collection => @entries }
    end
  end

  # GET
  def starred
    @entries = FeedEntry.where(:starred => true).order("id DESC")

    respond_to do |format|
      format.json { render json: @entries }
      format.js { render 'rss_streams/show', :collection => @entries }
    end
  end

  # GET
  def settings
    respond_to do |format|
      format.js
    end
  end
end
