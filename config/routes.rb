Rails.application.routes.draw do
  get "home/result" => "home#result"
  get "home/go_home" => "home#go_home"
  get "home/go_home_result" => "home#go_home_result"
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
