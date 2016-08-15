defmodule Organizer.AlertController do
  use Organizer.Web, :controller

  alias Organizer.Alert

  plug :scrub_params, "alert" when action in [:create, :update]

  def index(conn, %{"client_id" => client_id}) do
    scrub_params(conn, "client_id")
    alerts = Repo.all(from a in Alert, where: a.client_id == ^client_id)
    render(conn, "index.html", alerts: alerts)
  end

  def new(conn, %{"client_id" => client_id}) do
    changeset = Alert.changeset(%Alert{})
    render(conn, "new.html", changeset: changeset, client_id: client_id)
  end

  def create(conn, %{"alert" => alert_params}) do
    changeset = Alert.changeset(%Alert{}, alert_params)
    case Repo.insert(changeset) do
      {:ok, _alerts} ->
        conn
        |> put_flash(:info, gettext("Alert created successfully."))
        |> redirect(to: client_path(conn, :show, alert_params["client_id"]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, client_id: alert_params["client_id"])
    end
  end

  def show(conn, %{"id" => id}) do
    alert = Repo.get!(Alert, id)
    render(conn, "show.html", alert: alert)
  end

  def edit(conn, %{"id" => id}) do
    alert = Repo.get!(Alert, id)
    changeset = Alert.changeset(alert)
    render(conn, "edit.html", alert: alert, changeset: changeset)
  end

  def update(conn, %{"id" => id, "alert" => alert_params}) do
    alert = Repo.get!(Alert, id)
    changeset = Alert.changeset(alert, alert_params)

    case Repo.update(changeset) do
      {:ok, _alert} ->
        conn
        |> put_flash(:info, gettext("Alert updated successfully."))
        |> redirect(external: Organizer.Utilities.get_referer(conn))
      {:error, changeset} ->
        render(conn, "edit.html", alert: alert, changeset: changeset, client_id: alert_params["client_id"])
    end
  end

  def update_status(conn, %{"id" => id, "status" => status}) do
    alert = Repo.get!(Alert, id)
    changeset = Alert.changeset(alert, %{status: status})
    case Repo.update(changeset) do
      {:ok, _alert} ->
        conn
        |> redirect(to: dashboard_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> redirect(to: dashboard_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    alert = Repo.get!(Alert, id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(alert)
    conn
    |> put_flash(:info, gettext("Alert deleted successfully."))
    |> redirect(external: Organizer.Utilities.get_referer(conn))
  end
end
