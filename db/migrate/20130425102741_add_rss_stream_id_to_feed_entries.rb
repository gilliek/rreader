class AddRssStreamIdToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :rss_stream_id, :integer
  end
end
