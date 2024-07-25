Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "static#home"
  get "letters/:id", to: "letters#show"
  get "letters/:id/featured", to: "letters#featured"
  get "letters/:id/followers", to: "letters#followers"
  get "letters/:id/following", to: "letters#following"

  get "/.well-known/webfinger", to: "well_known#webfinger"

  get "notes/:id", to: "notes#show", constraints: {id: /\d*/}
  get "notes/:id", to: "notes#rand", constraints: {id: /./}

  post "/inbox", to: "box#in"
  get "/outbox", to: "box#out"
end
