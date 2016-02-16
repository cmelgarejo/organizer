defmodule Organizer.Utilities do
  import Plug.Conn, only: [get_session: 2, put_session: 3, assign: 3]
  import Organizer.Gettext

  def day_of_each_month(day) do
    day = if (day < 10), do: ("0" <> to_string(day)), else: to_string(day)
    gettext("The ") <> day <> gettext(" of each month")
  end

  def json_parse_text(text) do
    if text != nil do
      String.replace(text, "\r\n", "\\n")
    else
      ""
    end
  end

  def l10n_select_date_months() do
    [{"Enero", 1}, {"Febrero", 2}, {"Marzo", 3}, {"Abril", 4}, {"Mayo", 5}, {"Junio", 6}, {"Julio", 7}, {"Agosto", 8}, {"Setiembre", 9}, {"Octubre", 10}, {"Noviembre", 11}, {"Diciembre", 12}]
  end
  @doc """
  Assigns the session to the current Plug.conn
  """
  def organizer_session(conn) do
    #IO.puts("SESSION: #{inspect get_session(conn, :session)}")
    if (session = get_session(conn, :session)), do: session, else: nil
  end

  def remove_list_from_list(l, ltr) do
    remove_list(l, ltr)
  end

  @doc """
  Removes a list of elements from another list, given they exist on said list.
  """
  def remove_list(l, ltr) do
    if (!Enum.empty?ltr), do:
      remove_list(List.delete(l, hd(ltr)), List.delete(ltr, hd(ltr))),
    else:
      l
  end

end
