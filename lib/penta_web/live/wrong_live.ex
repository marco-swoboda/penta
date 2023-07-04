defmodule PentaWeb.WrongLive do
  use PentaWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, score: 0, message: "Guess a number.", number: Enum.random(1..10), won: false)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      <.button :if={@won} phx-click="restart" class="ml-2">
        Restart!
      </.button>
    </h2>
    <h2 :if={not @won}>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("guess", %{"number" => number}, socket) do
    {guess, _} = Integer.parse(number)

    if guess == socket.assigns.number do
      {:noreply,
       socket
       |> assign(
         message: "#{guess} was correct. Congratulations.",
         won: true
       )}
    else
      {:noreply,
       socket
       |> assign(
         message: "Your guess: #{number}. Wrong. Guess again. ",
         score: socket.assigns.score - 1
       )}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("restart", _params, socket) do
    {:noreply,
     assign(socket, score: 0, message: "Guess a number.", number: Enum.random(1..10), won: false)}
  end
end
