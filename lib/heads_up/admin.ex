defmodule HeadsUp.Admin do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Categories.Category
  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def create_incident(attrs \\ %{}) do
    %Incident{}
    |> Incident.changeset(attrs)
    |> Repo.insert()
  end

  def update_incident(%Incident{} = incident, attrs) do
    incident
    |> change_incident(attrs)
    |> Repo.update()
  end

  def delete_incident(id) do
    id
    |> get_incident!()
    |> Repo.delete()
  end

  def get_category_options do
    Category
    |> select([c], {c.name, c.id})
    |> order_by(:name)
    |> Repo.all()
  end

  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    Incident.changeset(incident, attrs)
  end
end
