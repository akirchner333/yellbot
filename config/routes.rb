Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "static#home"
  get "letters/:id", to: "letters#show"
  post "letters", to: "letters#search"
  get "random", to: "letters#random"
  get "letters/:id/featured", to: "letters#featured"
  get "letters/:id/followers", to: "letters#followers"
  get "letters/:id/following", to: "letters#following"

  get "/.well-known/webfinger", to: "well_known#webfinger"

  get "notes/:id", to: "notes#show", constraints: {id: /\d*/}
  get "notes/:id/replies", to: "notes#replies"
  # get "notes/:id", to: "notes#rand", constraints: {id: /./}

  # post "/inbox", to: "box#in"
  post "letters/:id/inbox", to: "box#in"
  get "letters/:id/outbox", to: "box#outbox"

  get "/actions/:id", to: "actions#show"
end
