defmodule Organizer.Utilities do
  import Plug.Conn, only: [get_session: 2, put_session: 3]
  import Organizer.Gettext
  alias Enum,   as: E
  alias String, as: S

  def get_referer(conn) do
    (conn.req_headers |> Enum.into(%{}))["referer"]
  end

  def day_of_each_month(day) do
    day = if (day < 10), do: ("0" <> to_string(day)), else: to_string(day)
    gettext("The ") <> day <> gettext(" of each month")
  end

  def json_parse_text(text) do
    if text != nil do
      String.replace(text, "\r\n", "\\n")
      |> String.replace("\\", "\\\\")
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

  @doc """
    Converts a result from Ecto.Adapters.SQL.query to a map %{} (JSON parseable)

    table: A Ecto table result (map) from Ecto.Adapters.SQL.query i.e:
    %{columns: ["col1", "col2", "col3"], command: :select, num_rows: 1,
      rows: [{1, "value1", nil}]}

    filter:  Contains a list of keys that should be used and taken if present
    (exclusively)
    """
  def table_to_map(table, filter \\ []) do
    try do
      if elem(table, 0) == :ok do
        table = elem table, 1
        if table.num_rows > 0 do
          result = (for r <- table.rows, do:
            E.zip((table.columns |> E.map(&(S.to_atom &1))), r) |> E.into(%{}))
         { table.num_rows,
           (if (!E.empty?filter), do:
             (for m <- result, do: Map.take(m, filter)), else: result) }
        else
          { 0, [] }
        end
      else
        error_logger "SQL Query failed", __ENV__, %{table: table}
      end
    rescue
      e in _ ->
        error_logger e, __ENV__, %{table: table}
        raise e
    end
  end

  @doc """
  Pretty prints any error you pass on to this func.

  ex  : exception object
  env: __ENV__ object of the function
  vars: a map with all the vars you want to control. i.e: %{var1: var1}
  """
  def error_logger(ex, env, vars \\ []) do
    env = Macro.Env.stacktrace(env) |> hd
    message = "[#{env |> elem(0)}.#{env |> elem(1)}]: #{inspect ex}
    file: #{env |> elem(3) |> hd |> elem(1)}
    line: #{env |> elem(3) |> tl |> hd |> elem(1)}
    vars: #{inspect vars}"
    message #let's return the message to debug
  end

end
