class AddStarredToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :starred, :boolean
  end
end
