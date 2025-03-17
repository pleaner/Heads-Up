defmodule HeadsUpWeb.Api.CategoryController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Categories

  def show(conn, %{"id" => id}) do
    render(conn, %{category: Categories.get_category_with_incidents!(id)})
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: HeadsUpWeb.ErrorJSON)
      |> render(:"404")
  end
end
