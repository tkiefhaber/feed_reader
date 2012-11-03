class FeedEntry < ActiveRecord::Base
  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
  end

  def self.update_from_feed_continuously
    people_news = "http://rss.people.com/web/people/rss/topheadlines/index.xml"
    wwtdd = "http://www.wwtdd.com/feed"
    uncrate = "http://feeds.feedburner.com/uncrate"
    devour = "http://feeds.feedburner.com/devourfeed"
    loop do
      sleep 3.minutes
      feed_urls = [people_news, wwtdd, uncrate, devour]
      feed_urls.each do |feed_url|
        feed = Feedzirra::Feed.fetch_and_parse(feed_url)
        add_entries(feed.entries)
        feed = Feedzirra::Feed.update(feed)
        add_entries(feed.new_entries) if feed.updated?
      end
    end
  end

  private

  def self.add_entries(entries)
    entries.each do |entry|
      unless exists? :guid => entry.id
        create!(
          :name         => entry.title,
          :summary      => entry.summary,
          :url          => entry.url,
          :published_at => entry.published,
          :guid         => entry.id
        )
      end
    end
  end
end
