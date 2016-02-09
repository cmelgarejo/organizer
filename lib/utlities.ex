defmodule Organizer.Utilities do
  import Plug.Conn, only: [get_session: 2, put_session: 3, assign: 3]
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
