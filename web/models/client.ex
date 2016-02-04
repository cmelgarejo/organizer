defmodule Organizer.Client do
  use Organizer.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "clients" do
    field :name, :string
    field :doc, :string
    field :charge_rate, :decimal
    field :charge_date, Ecto.Date
    field :email, :string
    field :phone, :string

    belongs_to :user, Organizer.User
    has_many :alert, Organizer.Alert, on_delete: :delete_all
    timestamps
  end

  @required_fields ~w(name doc user_id)
  @optional_fields ~w(charge_rate email phone)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
