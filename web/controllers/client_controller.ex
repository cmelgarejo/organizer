defmodule Organizer.ClientController do
  use Organizer.Web, :controller

  import Organizer.Utilities

  alias Organizer.Client

  plug :scrub_params, "client" when action in [:create, :update]

  def index(conn, _params) do
    {conn, session} = organizer_session(conn)
    IO.puts "SESSION: #{inspect session}"
    if(session == :error) do
      redirect conn, to: login_path(conn, :index)
    else #do your stuff and render the page.
      try do
        clients = Repo.all(from c in Client, where: c.user_id == ^session.user_id)
        render(conn, "index.html", clients: clients)
      catch
        _,_ ->  conn |> put_flash(:info, gettext("Alert created successfully."))
      end
    end
  end

  def new(conn, _params) do
    changeset = Client.changeset(%Client{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"client" => client_params}) do
    changeset = Client.changeset(%Client{}, client_params)

    case Repo.insert(changeset) do
      {:ok, _client} ->
        conn
        |> put_flash(:info, "Client created successfully.")
        |> redirect(to: client_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    client = Repo.get!(Client, id)
    render(conn, "show.html", client: client)
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
        |> put_flash(:info, "Client updated successfully.")
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
    |> put_flash(:info, "Client deleted successfully.")
    |> redirect(to: client_path(conn, :index))
  end
end
