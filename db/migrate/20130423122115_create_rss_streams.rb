class CreateRssStreams < ActiveRecord::Migration
  def change
    create_table :rss_streams do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
