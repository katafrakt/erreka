defmodule RethinkDatabase do 
  use RethinkDB.Ecto.Connection

  def tables do
    ["users"]
  end
end
