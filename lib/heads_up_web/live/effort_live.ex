defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    socket =
      assign(socket, responders: 3, minutes_per_responder: 10, increment: 1, page_title: "Effort")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <section>
        <button phx-click="add" phx-value-quatity={"#{@increment}"}>+{@increment}</button>
        <button phx-click="remove" phx-value-quatity={"#{@increment}"}>-{@increment}</button>
        <div>
          {@responders} responders
        </div>
        &times;
        <div>
          {@minutes_per_responder} min
        </div>
        =
        <div>
          {@minutes_per_responder * @responders} min
        </div>
      </section>

      <form phx-submit="set-price">
        <label>Minutes Per Responder:</label>
        <input type="number" name="minutes" value={@minutes_per_responder} />
      </form>

      <form phx-submit="set-increment">
        <label>Increment:</label>
        <input type="number" name="amount" value={@increment} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quatity" => quatity}, socket) do
    {:noreply, update(socket, :responders, &(&1 + String.to_integer(quatity)))}
  end

  def handle_event("remove", %{"quatity" => quatity}, socket) do
    {:noreply, update(socket, :responders, &(&1 - String.to_integer(quatity)))}
  end

  def handle_event("set-price", %{"minutes" => minutes}, socket) do
    {:noreply, assign(socket, :minutes_per_responder, String.to_integer(minutes))}
  end

  def handle_event("set-increment", %{"amount" => amount}, socket) do
    {:noreply, assign(socket, :increment, String.to_integer(amount))}
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :responders, &(&1 + 1))}
  end
end
