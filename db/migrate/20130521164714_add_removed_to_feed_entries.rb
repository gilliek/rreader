class AddRemovedToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :removed, :boolean, :default => false
  end
end
