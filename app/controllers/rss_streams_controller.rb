class RssStreamsController < ApplicationController
  # GET /rss_streams
  # GET /rss_streams.json
  def index
    @rss_streams = RssStream.all

    respond_to do |format|
      format.js
    end
  end

  # GET /rss_streams/1
  # GET /rss_streams/1.json
  def show
    @rss_stream = RssStream.where(:id => params[:id]).first
    @rss_stream.load_feed_entries
    @entries = FeedEntry.all_by_stream(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # GET /rss_streams/new
  # GET /rss_streams/new.json
  def new
    @rss_stream = RssStream.new

    respond_to do |format|
      format.js
    end
  end

  # GET /rss_streams/1/edit
  def edit
    @rss_stream = RssStream.find(params[:id])
  end

  # POST /rss_streams
  # POST /rss_streams.json
  def create
    @rss_stream = RssStream.new(params[:rss_stream])

    respond_to do |format|
      if @rss_stream.save
        @streams = RssStream.all_by_title
        format.js
      else
        format.js
      end
    end
  end

  # PUT /rss_streams/1
  # PUT /rss_streams/1.json
  def update
    @rss_stream = RssStream.find(params[:id])

    respond_to do |format|
      if @rss_stream.update_attributes(params[:rss_stream])
        @streams = RssStream.all_by_title
        @stream_title = @rss_stream.title
        format.js
      else
        format.js
      end
    end
  end

  # DELETE /rss_streams/1
  # DELETE /rss_streams/1.json
  def destroy
    @rss_stream = RssStream.find(params[:id])
    @rss_stream.destroy

    @streams = RssStream.all_by_title
    @entries = FeedEntry.order("id DESC").limit(5)

    respond_to do |format|
      format.js
    end
  end
end
