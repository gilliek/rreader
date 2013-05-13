class AddReadToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :read, :boolean
  end
end
