defmodule Organizer.Alert do
  use Organizer.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "alerts" do
    field :description, :string
    field :due_date, Ecto.DateTime
    field :notes, :string
    field :status, :boolean, default: false

    belongs_to :client, Organizer.Client
    timestamps
  end

  @required_fields ~w(description due_date )
  @optional_fields ~w(notes status client_id)

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
