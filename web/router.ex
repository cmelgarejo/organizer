defmodule Organizer.Router do
  use Organizer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Organizer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    # resources "/register", RegisterController

    resources "/users", UserController
    resources "/clients", ClientController
    resources "/alerts", AlertController
    resources "/login", LoginController
    resources "/register", RegisterController
    # get    "/clients/:client_id/alerts",          AlertController, :index
    # get    "/clients/:client_id/alerts/edit/:id", AlertController, :edit
    # get    "/clients/:client_id/alerts/new",      AlertController, :new
    # get    "/clients/:client_id/alerts/:id",      AlertController, :show
    # post   "/clients/:client_id/alerts",          AlertController, :create
    # patch  "/clients/:client_id/alerts/:id",      AlertController, :update
    # put    "/clients/:client_id/alerts/:id",      AlertController, :update
    # delete "/clients/:client_id/alerts/:id",      AlertController, :delete
  end

  scope "/auth", Organizer do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
    # will allow you to have access to the current user in your views with
    # `@current_user`.
    defp assign_current_session(conn, _) do
      assign(conn, :current_session, get_session(conn, :current_session))
    end
end
