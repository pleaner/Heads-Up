defmodule HeadsUpWeb.Api.IncidentController do
  alias HeadsUp.Admin
  use HeadsUpWeb, :controller

  def index(conn, _params) do
    incidents = Admin.list_incidents()

    render(conn, :index, incidents: incidents)
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: HeadsUpWeb.ErrorJSON)
      |> render(:"404")
  end

  def show(conn, %{"id" => id}) do
    incident = Admin.get_incident!(id)

    render(conn, :show, incident: incident)
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> put_view(json: HeadsUpWeb.ErrorJSON)
      |> render(:"404")
  end

  def create(conn, %{"incident" => incident}) do
    case Admin.create_incident(incident) do
      {:ok, incident} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/incidents/#{incident}")
        |> render(:show, incident: incident)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end
end
