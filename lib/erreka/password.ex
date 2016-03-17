defmodule Erreka.Password do
  alias RethinkDatabase, as: RDB
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @doc """
    Generates a password for the user changeset and stores it to the changeset as encrypted_password.
  """

  def generate_password(changeset) do
    put_change(changeset, :crypted_password, hashpwsalt(changeset.params["password"]))
  end

  @doc """
    Generates the password for the changeset and then stores it to the database.
  """
  def generate_password_and_store_user(changeset) do
    user_data = changeset
      |> generate_password

    {:ok, user} = RDB.insert(user_data)
    user
  end
end
