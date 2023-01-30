Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only:[:create]
      resources :user_list_items, only:[:create,:update,:destroy]
      resources :user_purchase_items, only:[:create]
    end
    namespace 'v2' do
      resources :users
    end
  end
end
