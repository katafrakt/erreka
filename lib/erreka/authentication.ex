defmodule Erreka.Plug.Authenticate do
  import Plug.Conn
  import Erreka.Router.Helpers
  import Phoenix.Controller
  alias RethinkDatabase, as: RDB
  import RethinkDB.Query
  alias Erreka.User

  def init(default), do: default

  def call(conn, default) do
    user_id = get_session(conn, :current_user)

    user = case user_id do
             nil -> nil
             _ -> RDB.get(User, user_id)
    end
    assign(conn, :current_user, user)
  end
end
