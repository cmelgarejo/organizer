defmodule Organizer.DashboardController do
  use Organizer.Web, :controller

  plug Organizer.Plug.Authenticate

  def index(conn, _params) do
    try do
      session = organizer_session(conn)
      clients = Repo.all(from c in Organizer.Client,
        join: a in assoc(c, :alerts),
        where: c.user_id == ^session.id and a.status == false,
        preload: [alerts: a])
      render(conn, "index.html", clients: clients)
    rescue
       _ in _ ->  conn |> put_flash(:error, gettext("An error has ocurred, please contact with the system administrator"))
    end
  end

  defimpl Poison.Encoder, for: Organizer.Client do
    # This is a sigil that produces a list of atoms
    @attributes ~W(id name email phone)a

    def encode(client, _options) do
      client
      |> Map.take(@attributes)
      |> Poison.encode!
    end
  end

  defimpl Poison.Encoder, for: Organizer.Alert do
    # This is a sigil that produces a list of atoms
    @attributes ~W(description due_date notes status client_id client)a

    def encode(alert, _options) do
      alert
      |> Map.take(@attributes)
      |> Poison.encode!
    end
  end

  def grid_data(conn, _params) do
    try do
      session = organizer_session(conn)
      clients = Repo.all(from a in Organizer.Alert,
        join: c in assoc(a, :client),
        where: c.user_id == ^session.id and a.status == false,
        preload: [client: c])
      json(conn, clients)
    rescue
       _ in _ ->  conn |> put_flash(:error, gettext("An error has ocurred, please contact with the system administrator"))
    end
  end
end
