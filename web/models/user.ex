defmodule Organizer.User do
  use Organizer.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    field :doc, :string
    field :password, :string
    field :dob, Ecto.Date
    field :gender, :string
    field :image_url, :string
    field :email, :string, read_after_writes: true
    field :timezone, :decimal
    field :locale, :string
    field :demo, :boolean, default: false
    field :active, :boolean, default: false
    field :xtra_info, :map
    has_many :client, Organizer.Client, on_delete: :delete_all
    timestamps
  end

  @required_fields ~w(email password name doc demo active)
  @optional_fields ~w(dob gender image_url email timezone locale xtra_info)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
