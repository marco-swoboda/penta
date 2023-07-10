defmodule PentaWeb.PromoLive do
  use PentaWeb, :live_view
  alias Penta.Promo
  alias Penta.Promo.Recipient

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> assign_changeset()}
  end

  defp assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  defp assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign_form(Promo.change_recipient(recipient))
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"recipient" => recipient}, socket) do
    changeset =
      socket.assigns.recipient
      |> Promo.change_recipient(recipient)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"recipient" => recipient}, socket) do
    # Send promo
    :timer.sleep(1000)

    {:noreply, socket |> assign_recipient |> assign_changeset}
  end

  defp assign_form(socket, changeset) do
    socket
    |> assign(:changeset, to_form(changeset))
  end
end
