Rails.application.routes.draw do
  namespace :api do
    get "journal/months", to: "journal#months"
    get "journal/:month", to: "journal#show"
  end

  mount MaintenanceTasks::Engine, at: "/maintenance_tasks"
  root "maintenance_tasks/tasks#index"
end
