defmodule HeadsUpWeb.CustomComponents do
  use Phoenix.Component
  use HeadsUpWeb, :verified_routes

  embed_templates "custom_components/*"

  attr :status, :atom, values: [:pending, :resolved, :canceled], default: :pending
  attr :class, :string, default: nil
  attr :rest, :global
  def badge(assigns)

  slot :inner_block, required: true
  slot :tagline

  def headline(assigns) do
    assigns = assign(assigns, :emoji, ~w(🚒 🚑 🚁 🚓) |> Enum.random())

    ~H"""
    <div class="headline">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={tagline <- @tagline} class="tagline">
        {render_slot(tagline, @emoji)}
      </div>
    </div>
    """
  end
end
