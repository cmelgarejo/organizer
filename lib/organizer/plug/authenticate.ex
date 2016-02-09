defmodule Organizer.Plug.Authenticate do
  import Plug.Conn
  import Organizer.Router.Helpers
  import Phoenix.Controller
  import Organizer.Gettext

  def init(options), do: options

  def call(conn, _options) do
    session = get_session(conn, :session)
    if session do
      conn
    else
      conn
        |> put_flash(:error, gettext("You need to be signed in to view this page"))
        |> redirect(to: session_path(conn, :index))
    end
  end

end
