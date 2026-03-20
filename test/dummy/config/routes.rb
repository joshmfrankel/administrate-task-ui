Rails.application.routes.draw do
  namespace :admin do
    resources :task_runs, only: [ :new, :create, :index, :show ] do
      get "source_code", on: :collection
    end

    root to: "task_runs#index"
  end
end
