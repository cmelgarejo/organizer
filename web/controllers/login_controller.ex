defmodule Organizer.LoginController do
  use Organizer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end