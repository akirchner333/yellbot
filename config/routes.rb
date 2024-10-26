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

  scope "/.well-known" do
    get "/webfinger", to: "well_known#webfinger"
    get "/nodeinfo", to: "well_known#nodeinfo"
    get "/host-meta", to: "well_known#hostmeta"
  end

  scope "/nodeinfo" do
    get "/2.0", to: "node_info#twozero"
    get "/2.1", to: "node_info#twoone"
  end

  get "notes/:id", to: "notes#show", constraints: {id: /\d*/}
  get "notes/:id/replies", to: "notes#replies"
  # get "notes/:id", to: "notes#rand", constraints: {id: /./}

  # post "/inbox", to: "box#in"
  post "letters/:id/inbox", to: "box#in"
  get "letters/:id/outbox", to: "box#outbox"

  get "/actions/:id", to: "actions#show"
end
