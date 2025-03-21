defmodule HeadsUp.Incidents do
  alias HeadsUp.Categories.Category
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
    |> Repo.preload(:category)
  end

  def urgent_incidents(incident) do
    # Process.sleep(300)

    Incident
    |> order_by(desc: :priority)
    |> limit(3)
    |> Repo.all()
    |> List.delete(incident)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> with_category(filter["category"])
    |> sort(filter["sort_by"])
    |> preload(:category)
    |> Repo.all()
  end

  defp with_status(query, status)
       when status in ~w(canceled resolved pending) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [incident], ilike(incident.name, ^"%#{q}%"))
  end

  defp with_category(query, slug) when slug in ["", nil], do: query

  defp with_category(query, slug) do
    query
    |> join(:inner, [r], c in Category, on: r.category_id == c.id)
    |> where([r, c], c.slug == ^slug)
  end

  defp sort(query, "name"), do: order_by(query, asc: :name)
  defp sort(query, "priority_desc"), do: order_by(query, desc: :priority)
  defp sort(query, "priority_asc"), do: order_by(query, asc: :priority)

  defp sort(query, "category") do
    query
    |> join(:inner, [r], c in assoc(r, :category))
    |> order_by([r, c], asc: c.name)
  end

  defp sort(query, _), do: order_by(query, asc: :id)

  def status_options do
    Ecto.Enum.values(Incident, :status)
  end
end
