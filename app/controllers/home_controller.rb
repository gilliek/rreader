class HomeController < ApplicationController
  # GET
  def index
    urls = RssStream.select("rss_streams.url")
                    .where(:user_id => current_user.id)
                    .map { |v| v[:url] }

    RssStream.update_all_feeds(urls, current_user.id)

    @entries = FeedEntry.joins(:rss_stream)
                        .where("rss_streams.user_id = ? AND " +
							   "feed_entries.removed = ?",
							   current_user.id, false)
                        .order("published_at DESC")
                        .limit(42)

    respond_to do |format|
      format.html
      format.json { render json: @entries }
      format.js { render 'rss_streams/show', :collection => @entries }
    end
  end

  # GET
  def starred
    @entries = FeedEntry.joins(:rss_stream)
                        .where("feed_entries.starred = ? AND " +
                               "rss_streams.user_id = ? AND " +
							   "feed_entries.removed = ?",
                               true, current_user.id, false)
                        .order("published_at DESC")

    respond_to do |format|
      format.json { render json: @entries }
      format.js { render 'rss_streams/show', :collection => @entries }
    end
  end

  # GET
  def trash
	@entries = FeedEntry.joins(:rss_stream)
						.where("rss_streams.user_id = ? AND " +
							   "feed_entries.removed = ?",
							   current_user.id, true)
						.order("published_at DESC")
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
