Dummy::Application.routes.draw do
  resources :countries do
    resources :cities do
      resources :streets
    end
  end
end
