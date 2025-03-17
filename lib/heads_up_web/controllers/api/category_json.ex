defmodule HeadsUpWeb.Api.CategoryJSON do
  def show(%{category: category}) do
    %{
      category: %{
        id: category.id,
        name: category.name,
        slug: category.slug,
        inciendents: for(incident <- category.incident, do: data(incident))
      }
    }
  end

  defp data(incident) do
    %{
      id: incident.id,
      priority: incident.priority,
      name: incident.name,
      description: incident.description,
      status: incident.status
    }
  end
end
