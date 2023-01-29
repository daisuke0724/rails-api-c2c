Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users
      resources :user_list_items
      resources :user_purchase_items
    end
    namespace 'v2' do
      resources :users
    end
  end
end
