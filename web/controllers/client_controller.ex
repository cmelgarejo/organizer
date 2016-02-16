defmodule Organizer.ClientController do
  use Organizer.Web, :controller

  alias Organizer.Client
  alias Organizer.Alert

  plug Organizer.Plug.Authenticate
  plug :scrub_params, "client" when action in [:create, :update]

  def index(conn, _params) do
    # try do
      session = organizer_session(conn)
      clients = Repo.all(from c in Client, where: c.user_id == ^session.id)
      render(conn, "index.html", clients: clients)
    # catch
    #   _,_ ->  conn |> put_flash(:error, gettext("An error has ocurred, please contact with the system administrator"))
    # end
  end

  def new(conn, _params) do
    session = organizer_session(conn)
    changeset = Client.changeset(%Client{user_id: session.id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"client" => client_params}) do
    session = organizer_session(conn)
    changeset = Client.changeset(%Client{user_id: session.id}, client_params)
    case Repo.insert(changeset) do
      {:ok, _client} ->
        conn
        |> put_flash(:info, gettext("Client created successfully."))
        |> redirect(to: client_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    session = organizer_session(conn)
    client = Repo.get_by!(Client, id: id, user_id: session.id)
    alerts = Repo.all(from a in Alert, where: a.client_id == ^id, order_by: [desc: a.status])
    render(conn, "show.html", client: client, alerts: alerts)
  end

  def edit(conn, %{"id" => id}) do
    client = Repo.get!(Client, id)
    changeset = Client.changeset(client)
    render(conn, "edit.html", client: client, changeset: changeset)
  end

  def update(conn, %{"id" => id, "client" => client_params}) do
    client = Repo.get!(Client, id)
    changeset = Client.changeset(client, client_params)
    case Repo.update(changeset) do
      {:ok, client} ->
        conn
        |> put_flash(:info, gettext("Client updated successfully."))
        |> redirect(to: client_path(conn, :show, client))
      {:error, changeset} ->
        render(conn, "edit.html", client: client, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    client = Repo.get!(Client, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(client)

    conn
    |> put_flash(:info, gettext("Client deleted successfully."))
    |> redirect(to: client_path(conn, :index))
  end
end
