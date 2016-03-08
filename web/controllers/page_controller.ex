defmodule Erreka.PageController do
  use Erreka.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
