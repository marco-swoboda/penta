defmodule PentaWeb.WrongLive do
  use PentaWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Guess a number.",
       number: Enum.random(1..10),
       items: 1..10,
       won: false,
       session_id: session["live_socket_id"]
     )}
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
      <%= for n <- @items do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
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
         items: socket.assigns.items |> Enum.reject(&(&1 == guess)),
         score: socket.assigns.score + 1
       )}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("restart", _params, socket) do
    {:noreply,
     assign(socket,
       score: 0,
       message: "Guess a number.",
       number: Enum.random(1..10),
       items: 1..10,
       won: false
     )}
  end
end
