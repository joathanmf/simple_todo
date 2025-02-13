Rails.application.routes.draw do
  root to: redirect("/tasks")

  resources :tasks do
    patch :update_status, on: :member
  end
end
