Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'images#index'

  resources :images

  get '/images/:id/share', to: 'images#share', as: 'share'
  post '/images/:id/share', to: 'images#send_share_email'
end
