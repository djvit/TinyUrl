# Application routes definition
Rails.application.routes.draw do

  # User actions
  resource :users,  only: [:create, :show]

  # Session actions
  resource :sessions, only: [:create, :show, :destroy]

  # Tiny URL actions
  resource :urls, only: [:create, :show]
  get '/:tiny_path', to: 'urls#access'

  # Root path
  root 'home#index'
end
