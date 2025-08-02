Rails.application.routes.draw do
  # トップ
  root "home#index"
  # 翻訳 /translations/new translation#new
  # 履歴 /translations translation#index
  resources :translations, only: [ :new, :create, :index ]
end
