defmodule Organizer.AuthController do
  use Organizer.Web, :controller

  def options(), do: Application.get_env(:organizer, Organizer.AuthController)
  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    if !(options[:single_user]) do
      redirect conn, external: authorize_url!(provider)
    else
      oauth_data = %{name: options[:user].name, doc: options[:user].doc, password: options[:user].password,
      dob: options[:user].birthday, gender: options[:user].gender, image_url: options[:user].image_url,
      email: options[:user].email, timezone: options[:user].timezone, locale: options[:user].locale,
      demo: options[:user].demo, active: options[:user].active, xtra_info: options[:user].xtra_info}

      user = Repo.get_by(Organizer.User, email: oauth_data.email)

      if (user == nil) do
        user = Organizer.User.changeset(%Organizer.User{}, oauth_data)

        case Repo.insert(user) do
          {:ok, _user} ->
            #READ BACK FROM DB WITH EMAIL
            user = Repo.get_by(Organizer.User, email: oauth_data.email)
            start_session(conn, Map.merge(oauth_data, %{id: user.id}), %{access_token: user.id})
          {:error, _changeset} ->
            conn
            |> put_flash(:error, gettext("User cannot be created.") )
            |> redirect(to: register_path(conn, :index))
        end
      else
        start_session(conn, Map.merge(oauth_data, %{id: user.id}), %{access_token: user.id})
      end
    end
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    try do
      # Exchange an auth code for an access token
      token = get_token!(provider, code)
      # Request the user's data with the access token
      #READ FROM DB WITH EMAIL FIRSTs
      oauth_data = get_user!(provider, token)

      user = Repo.get_by(Organizer.User, email: oauth_data.email)

      if (user == nil) do
        user = Organizer.User.changeset(%Organizer.User{}, oauth_data)

        case Repo.insert(user) do
          {:ok, _user} ->
            #READ BACK FROM DB WITH EMAIL
            user = Repo.get_by(Organizer.User, email: oauth_data.email)
            start_session(conn, Map.merge(oauth_data, %{id: user.id}), token)
          {:error, _changeset} ->
            conn
            |> put_flash(:error, gettext("User cannot be created."))
            |> redirect(to: register_path(conn, :index))
        end
      else
        start_session(conn, Map.merge(oauth_data, %{id: user.id}), token)
      end
      #IO.puts "USER: #{inspect user}"
      # Store the user in the session under `:current_user` and redirect to /.
      # In most cases, we'd probably just store the user's ID that can be used
      # to fetch from the database. In this case, since this example app has no
      # database, I'm just storing the user map.
      #
      # If you need to make additional resource requests, you may want to store
      # the access token as well.
    rescue
      e in Exception ->
        conn
        |> put_status(500)
        |> put_flash(:error, gettext("User cannot be created.") <> e.message)
    end
  end

  defp start_session(conn, user, token), do:
    conn
    |> put_session(:session, user |> Map.take([:id, :name, :doc, :password, :dob, :gender, :image_url, :email, :timezone, :locale, :demo, :active, :xtra_info]))
    |> put_session(:access_token, token.access_token)
    |> redirect(to: dashboard_path(conn, :index))

  defp authorize_url!("github"),   do: GitHub.authorize_url!
  defp authorize_url!("google"),   do: Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  defp authorize_url!("facebook"), do: Facebook.authorize_url!(scope: "public_profile,email")
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("github", code),   do: GitHub.get_token!(code: code)
  defp get_token!("google", code),   do: Google.get_token!(code: code)
  defp get_token!("facebook", code), do: Facebook.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  #   field :name, :string
  #   field :doc, :string
  #   field :password, :string
  #   field :dob, Ecto.Date
  #   field :gender, :string
  #   field :image_url, :string
  #   field :email, :string, read_after_writes: true
  #   field :timezone, :decimal
  #   field :locale, :string
  #   field :demo, :boolean, default: false
  #   field :active, :boolean, default: false
  #   field :xtra_info, :map

  defp get_user!("github", token) do
    {:ok, %{body: user}} = OAuth2.AccessToken.get(token, "/user")
    %{name: user["name"], doc: nil, password: user["email"],
    dob: user["birthday"], gender: user["gender"], image_url: user["avatar_url"],
    email: user["email"], timezone: user["timezone"], locale: user["locale"],
    demo: true, active: true, xtra_info: Map.merge(user, %{access_token: token.access_token})}
  end
  defp get_user!("google", token) do
    {:ok, %{body: user}} = OAuth2.AccessToken.get(token, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    %{name: user["name"], doc: nil, password: user["email"],
    dob: user["birthday"], gender: user["gender"], image_url: user["picture"],
    email: user["email"], timezone: user["timezone"], locale: user["locale"],
    demo: true, active: true, xtra_info: Map.merge(user, %{access_token: token.access_token})}
  end
  defp get_user!("facebook", token) do
    {:ok, %{body: user}} = OAuth2.AccessToken.get(token, "/me?fields=id,name,email,timezone,locale,gender,bio,birthday,age_range")
    avatar = case HTTPoison.get("https://graph.facebook.com/#{user["id"]}/picture?type=large&redirect=0") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body = Poison.decode! body
		    body["data"]["url"]
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "error:404"
      {:error, %HTTPoison.Error{reason: reason}} ->
        "error:" <> to_string(reason)
    end
    %{name: user["name"], doc: nil, password: user["email"],
    dob: user["birthday"], gender: user["gender"], image_url: avatar,
    email: user["email"], timezone: user["timezone"], locale: user["locale"],
    demo: true, active: true, xtra_info: Map.merge(user, %{fb_id: user["id"], access_token: token.access_token})}
  end
end
