Rails.application.routes.draw do
   # get 'albums/index'
   devise_for :users
   get 'albums/myalbum'
   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

   # Defines the root path route ("/")
   # root "articles#index"
   root "albums#index"
   resources :albums do
    member do
    delete:delete_image_attached
    end
   end
   get 'tags/:tag', to: 'albums#index', as: :tag
 end
