FeedReader::Application.routes.draw do

  resources :feed_entries
  root :to => "feed_entries#index"

end