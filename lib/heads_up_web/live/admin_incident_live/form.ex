defmodule HeadsUpWeb.AdminIncidentLive.Form do
  alias HeadsUp.Incidents.Incident
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin

  def mount(params, _session, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)
      |> assign(categories: Admin.get_category_options())

    {:ok, socket}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident)

    socket
    |> assign(page_title: "New Incident")
    |> assign(form: to_form(changeset))
    |> assign(incident: incident)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)

    changeset = Admin.change_incident(incident)

    socket
    |> assign(page_title: "Edit Incident")
    |> assign(form: to_form(changeset))
    |> assign(incident: incident)
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>

    <.simple_form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:name]} label="Name" placeholder="Name" phx-debounce="blur" />
      <.input
        field={@form[:description]}
        type="textarea"
        label="Description"
        placeholder="Description"
        phx-debounce="blur"
      />
      <.input field={@form[:priority]} type="number" label="Priority" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Set the Satatus"
        options={[:pending, :resolved, :canceled]}
      />
      <.input
        field={@form[:category_id]}
        type="select"
        label="Category"
        prompt="Select Category"
        options={@categories}
      />
      <.input field={@form[:image_path]} label="Image Path" placeholder="Image Path" />
      <:actions>
        <.button phx-disable-with="Saving...">Save</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/incidents"}>Back</.back>
    """
  end

  def handle_event("validate", %{"incident" => incident}, socket) do
    changeset = Admin.change_incident(socket.assigns.incident, incident)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"incident" => params}, socket) do
    save_incident(socket, socket.assigns.live_action, params)
  end

  defp save_incident(socket, :save, params) do
    case Admin.create_incident(params) do
      {:ok, incident} ->
        socket =
          socket
          |> put_flash(:info, "#{incident.name} Created.")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  defp save_incident(socket, :edit, params) do
    case Admin.update_incident(socket.assigns.incident, params) do
      {:ok, incident} ->
        socket =
          socket
          |> put_flash(:info, "#{incident.name} Updated")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end
end
