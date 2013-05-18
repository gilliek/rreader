class RssStream < ActiveRecord::Base
  attr_accessible :title, :url

  after_save :load_feed_entries

  has_many :feed_entries, :dependent => :destroy

  validates :title, :url, :presence => true
  validates :url, :format => {
    :with	 => /^https?:\/\/.+\.[a-z]{2,4}\//i,
    :message => 'must be a valid'
  }

  scope :all_by_title, order("UPPER(title) ASC")

  def load_feed_entries
    last_entry = self.feed_entries.last
    if last_entry.nil?
      feed = Feedzirra::Feed.fetch_and_parse(self.url)
    else
      feed = Feedzirra::Feed.fetch_and_parse(self.url,
        :if_modified_since => last_entry.published_at.to_time)
    end

    RssStream.add_entries(feed.entries, self.id)
  end

  def self.update_all_feeds(urls)
    Feedzirra::Feed.fetch_and_parse(urls,
      :on_success => lambda { |url, feed|
        rss = RssStream.select("rss_streams.id").where(:url => url).first
        RssStream.add_entries(feed.entries, rss.id)
      }
    )
  end

  private
    def self.add_entries(entries, stream_id)
      entries.each do |entry|
          unless  FeedEntry.exists?(:guid => entry.id)
            FeedEntry.create!(
              :name          => entry.title,
              :summary       => entry.summary,
              :url           => entry.url,
              :content       => entry.content,
              :published_at  => entry.published,
              :guid          => entry.id,
              :rss_stream_id => stream_id,
              :read          => false
            )
          end
      end
    end
end
