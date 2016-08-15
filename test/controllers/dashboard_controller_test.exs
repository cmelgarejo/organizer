defmodule Organizer.DashboardControllerTest do
  use Organizer.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Organizer"
  end
end
