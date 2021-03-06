defmodule Erreka.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use Erreka.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Erreka.Repository.UserRepository

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user = UserRepository.find_by_email(params["email"])

    case validate_credentials(auth.credentials, user) do
      :ok ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user.id)
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:error, "Username and password do not match")
        |> redirect(to: "/login")
    end
  end

  defp validate_credentials(credentials, user) when is_map(credentials) do
    cond do
      Comeonin.Bcrypt.checkpw(credentials.other.password, user.crypted_password) ->
        :ok
      true ->
        :error
    end
  end
end
