class RssStream < ActiveRecord::Base
  attr_accessible :title, :url, :user_id

  before_save :handle_empty_title

  has_many :feed_entries, :dependent => :destroy
  belongs_to :user

  validates :title, :presence => true, :on => :update
  validates :url, :format => {
    :with	 => /^https?:\/\/.+\.[a-z]{2,4}\//i,
    :message => 'must be a valid'
  }

  scope :all_by_title, lambda { |id| where(:user_id => id).order("UPPER(title) ASC") }

  # loads all entrie
  def load_feed_entries
    last_entry = self.feed_entries.last
    if last_entry.nil?
      feed = Feedzirra::Feed.fetch_and_parse(self.url)
    else
      feed = Feedzirra::Feed.fetch_and_parse(self.url,
        :if_modified_since => last_entry.published_at.to_time)
    end

    # update the feed title if required and possible
    if !feed.nil? && !feed.title.nil? && self.title != feed.title
      self.update_attributes({:title => feed.title})
    end

    RssStream.add_entries(feed.entries, self.id, self.user_id)
  end

  # updates the entries of the given URLs
  def self.update_all_feeds(urls, current_id)
    Feedzirra::Feed.fetch_and_parse(urls,
      :on_success => lambda { |url, feed|
        rss = RssStream.select("rss_streams.id").where(:url => url).first
        RssStream.add_entries(feed.entries, rss.id, current_id)
      }
    )
  end

  private
    def self.add_entries(entries, stream_id, current_id)
      entries.each do |entry|
          unless FeedEntry.joins(:rss_stream).where("rss_streams.user_id = ?", current_id).exists?(:guid => entry.id)
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

    def handle_empty_title
      self.title = "unknown" if title.nil? || title.empty?
    end
end
