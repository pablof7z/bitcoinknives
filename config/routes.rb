Rails.application.routes.draw do
  resources :rules do
    resources :trades
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # mount ActionCable.server => '/cable'
  get '/:page' => "pages#page"
  root to: 'pages#index'
end
