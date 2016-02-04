defmodule Organizer.UserTest do
  use Organizer.ModelCase

  alias Organizer.User

  @valid_attrs %{active: true, demo: true, dob: "2010-04-17", doc: "some content", email: "some content", gender: "some content", image_url: "some content", locale: "some content", name: "some content", password: "some content", timezone: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
