Dummy::Application.routes.draw do
  resources :languages
  resources :countries do
    resources :cities do
      resources :streets
    end
  end
end
