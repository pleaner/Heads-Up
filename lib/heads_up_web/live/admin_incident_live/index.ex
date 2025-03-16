defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: {"animate-bounce duration-1000", "opacity-0", "opacity-100"},
          out: {"animate-bounce duration-1000", "opacity-1000", "opacity-0"},
          time: 1000
        )
      }>
        Toggle Joke
      </.button>

      <div id="joke" class="joke hidden">
        Whats a Tree' Favoirite
        <span phx-click={JS.transition("shake", to: "#joke", time: 1000)}>Drink?</span>
      </div>

      <.header class="mt-6">
        {@page_title}
        <:actions>
          <.link class="button" navigate={~p"/admin/incidents/new"}>
            New Incident
          </.link>
        </:actions>
      </.header>

      <.table
        id="incidents"
        rows={@streams.incidents}
        row-click={fn {_id, incident} -> JS.navigate(~p"/incidents/#{incident}") end}
      >
        <:col :let={{_dom_id, incident}} label="Name">
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.name}
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Status">
          <.link navigate={~p"/incidents/#{incident}"}>
            <.badge status={incident.status} />
          </.link>
        </:col>
        <:col :let={{_dom_id, incident}} label="Priority">
          <.link navigate={~p"/incidents/#{incident}"}>
            {incident.priority}
          </.link>
        </:col>
        <:action :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident}/edit"}>
            <.icon name="hero-pencil-square" class="h-4 w-4" />
          </.link>
        </:action>
        <:action :let={{dom_id, incident}}>
          <.link
            phx-click={delete_and_hide(dom_id, incident)}
            data-confirm={"Are you sure you want to delete #{incident.name}?"}
          >
            <.icon name="hero-trash" class="h-4 w-4" />
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, incident} = Admin.delete_incident(id)

    socket =
      socket
      |> stream_delete(:incidents, incident)
      |> put_flash(:info, "Deleted #{incident.name}")

    {:noreply, socket}
  end

  def delete_and_hide(dom_id, incident) do
    JS.push("delete", value: %{id: incident.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
