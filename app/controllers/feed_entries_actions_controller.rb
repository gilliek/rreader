class FeedEntriesActionsController < ApplicationController
  # PUT
  def star_items
    err, id = update_items(params[:items], :starred, true)
    @entries = FeedEntry.all_by_stream(id)

    respond_to do |format|
      if err.empty?
        format.js
      else
        format.js err
      end
    end
  end

  # PUT
  def unstar_items
    err, id = update_items(params[:items], :starred, false)
    @entries = FeedEntry.all_by_stream(id)

    respond_to do |format|
      if err.empty?
        format.js
      else
        format.js err
      end
    end
  end

  # PUT
  def mark_as_read
    err, id = update_items(params[:items], :read, true)
    @entries = FeedEntry.all_by_stream(id)

    respond_to do |format|
      if err.empty?
        format.js
      else
        format.js err
      end
    end
  end

  # PUT
  def mark_as_unread
    err, id = update_items(params[:items], :read, false)
    @entries = FeedEntry.all_by_stream(id)

    respond_to do |format|
      if err.empty?
        format.js
      else
        format.js err
      end
    end
  end

  # DELETE
  def remove_items
    id = -1

    params[:items].each do |id|
      entry = FeedEntry.find(id)
      id = entry.rss_stream_id
      entry.destroy
    end

    @entries = FeedEntry.all_by_stream(id)

    respond_to do |format|
      format.js
    end
  end

  private
    def update_items(items, attr, value)
      errors_array = Array.new
      rss_stream_id = -1

      items.each do |id|
        entry = FeedEntry.find(id)

        rss_stream_id = entry.rss_stream_id

        if !entry.update_attribute(attr, value)
          errors_array << entry.errors
        end
      end

      return errors_array, rss_stream_id
    end
end
