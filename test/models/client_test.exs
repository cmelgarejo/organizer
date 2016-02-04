defmodule Organizer.ClientTest do
  use Organizer.ModelCase

  alias Organizer.Client

  @valid_attrs %{charge_date: "2010-04-17", charge_rate: "120.5", doc: "some content", email: "some content", name: "some content", phone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Client.changeset(%Client{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Client.changeset(%Client{}, @invalid_attrs)
    refute changeset.valid?
  end
end
