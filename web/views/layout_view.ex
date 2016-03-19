defmodule Erreka.LayoutView do
  use Erreka.Web, :view

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def signed_in?(conn) do
    case current_user(conn) do
      nil -> false
      _ -> true
    end
  end
end
