
defmodule Mix.Tasks.Rdb.Load do
  use Mix.Task
  import RethinkDB.Query
  alias RethinkDatabase, as: RDB

  def run(_args) do
    create_tables
  end

  def create_tables do
    RDB.start_link(Application.get_env(:erreka, :rdb))
    Enum.each(RethinkDatabase.tables, fn(table_name) ->
      query = table_list
        |> contains(table_name)
        |> branch("", do_r(fn -> table_create(table_name) end))
      case RDB.run(query) do
        %RethinkDB.Record{data: %{"tables_created" => 1}} ->
          IO.puts "Created table `#{table_name}`."
        %RethinkDB.Record{data: ""} ->
          IO.puts "Table `#{table_name}` already exists."
      end
    end)
  end
end
