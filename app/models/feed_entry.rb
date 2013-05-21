class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url, :content,
    :rss_stream_id, :read, :removed

  belongs_to :rss_stream

  scope :all_by_stream, lambda { |stream_id|
    where(:rss_stream_id => stream_id, :removed => false).order("published_at DESC")
  }
end
