defmodule HeadsUpWeb.TipsHTML do
  @moduledoc """
  This module contains tips rendered by TipController.

  See the `tips_html` directory for all templates available.
  """
  use HeadsUpWeb, :html

  embed_templates "tips_html/*"

  def show(assigns) do
    ~H"""
    <div class="tips">
      <h1>You Like a Tip, {@answer}</h1>
      <p>{@tip.text}</p>
      <p class="text-xs text-blue-gray-500 pt-3">
        <a href={~p"/tips"}>Back to Tips</a>
      </p>
    </div>
    """
  end
end
