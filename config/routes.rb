Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  get "restaurants", to: "restaurant#index"
  get "categories", to: "category#index"
end
