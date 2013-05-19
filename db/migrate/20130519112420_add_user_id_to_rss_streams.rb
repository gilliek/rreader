class AddUserIdToRssStreams < ActiveRecord::Migration
  def change
    add_column :rss_streams, :user_id, :integer
  end
end
