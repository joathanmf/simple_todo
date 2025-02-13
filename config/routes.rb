Rails.application.routes.draw do
  root to: redirect("/tasks")

  resources :tasks
end
