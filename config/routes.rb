ErpWorkers::Engine.routes.draw do
  namespace :accounts do
    resources :workers, only: [ :index, :create, :destroy ], param: :id, path: ":account_id/workers" do
      collection do
        get "/", to: "workers#index", as: ""
      end
    end
  end
end
