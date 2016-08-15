defmodule Organizer.SessionController do
  use Organizer.Web, :controller

  def index(conn, _params) do
    if Organizer.AuthController.options[:single_user] do
      conn
      |> clear_flash
      |> redirect(to: auth_path(conn, :index, "single_user"))
    else
      render conn, "index.html"
    end
  end

  def logout(conn, params) do
    delete(conn, params)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("You have been logged out!"))
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

end
