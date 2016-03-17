defmodule Erreka.RegistrationController do
  use Erreka.Web, :controller
  alias Erreka.Password

  # plug :action

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    if changeset.valid? do
      new_user = Password.generate_password_and_store_user(changeset)

      conn
        |> put_flash(:info, "Successfully registered and logged in")
        |> put_session(:current_user, new_user)
        |> redirect(to: "/")
    else
      render conn, "new.html", changeset: changeset
    end
  end
end