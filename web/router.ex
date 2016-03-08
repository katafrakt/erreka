defmodule Erreka.Router do
  use Erreka.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Erreka do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", AuthController, :login
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/logout", AuthController, :delete

    scope "/auth" do
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/identity/callback", AuthController, :identity_callback
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", Erreka do
  #   pipe_through :api
  # end
end
