defmodule Erreka.Repository.UserRepository do
  alias RethinkDatabase, as: RDB
  import RethinkDB.Query
  alias Erreka.User

  def find_by_email(email) do
    query = table("users") |>
      filter(%{email: email})
    RDB.query(User, query) |> List.first
  end
end
