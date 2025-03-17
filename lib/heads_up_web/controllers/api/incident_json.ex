defmodule HeadsUpWeb.Api.IncidentJSON do
  def index(%{incidents: inciendents}) do
    %{inciendents: for(incident <- inciendents, do: data(incident))}
  end

  def show(%{incident: incident}) do
    %{incident: data(incident)}
  end

  defp data(incident) do
    %{
      id: incident.id,
      priority: incident.priority,
      name: incident.name,
      description: incident.description,
      status: incident.status,
      category_id: incident.category_id
    }
  end

  def error(%{changeset: changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, &translate_error/1)

    %{errors: errors}
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
