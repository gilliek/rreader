class AddContentToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :content, :text
  end
end
