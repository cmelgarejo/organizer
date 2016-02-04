defmodule Organizer.Repo.Migrations.CreateClient do
  use Ecto.Migration

  def up do
    drop_if_exists table :alerts
    drop_if_exists table :clients
    drop_if_exists table :users

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :name, :string
      add :doc, :string
      add :password, :string, null: false
      add :dob, :date
      add :gender, :string
      add :image_url, :text
      add :timezone, :decimal
      add :locale, :string
      add :demo, :boolean, default: false
      add :active, :boolean, default: false
      add :xtra_info, :jsonb

      timestamps
    end
    create unique_index(:users, [:email])

    create table(:clients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :doc, :string, null: false
      add :charge_rate, :decimal
      add :charge_date, :date
      add :email, :string
      add :phone, :string

      timestamps
    end
    create index(:clients, [:user_id])
    create index(:clients, [:charge_date])

    create table(:alerts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :client_id, references(:clients, type: :binary_id, on_delete: :delete_all), null: false
      add :description, :text
      add :due_date, :datetime
      add :notes, :text
      add :status, :boolean, default: false

      timestamps
    end
    create index(:alerts, [:client_id])
    create index(:alerts, [:due_date])
    create index(:alerts, [:status])

  end

end
