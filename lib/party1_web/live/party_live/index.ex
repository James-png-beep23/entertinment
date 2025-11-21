defmodule Party1Web.PartyLive.Index do

  use Party1Web, :live_view


  @topic "party_updates"

  alias Party1.Server
  alias Party1.Context
  # alias Party1.Context.Event

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Party1.PubSub, @topic)
    party = Server.get_party()
    date = Date.utc_today()

    # Get current_user from socket assigns or set to nil if not available
    current_user = socket.assigns[:current_user]

    socket =
      socket
      |> assign(:now, date)
      |> assign(:events, party)
      |> assign(:current_user, current_user)  # Add this line

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("book", %{"event_id" => event_id, "number_of_attendees" => number_of_attendees}, socket) do
    event_id = String.to_integer(event_id)
    number_of_attendees = String.to_integer(number_of_attendees)

    remaining_seats = Server.get_remaining_seats(event_id, number_of_attendees)

    if remaining_seats >= 0 do
      {:noreply,
       socket
       |> put_flash(:info, "Successfully booked #{number_of_attendees} seats! Remaining seats: #{remaining_seats}")}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Booking failed. Not enough remaining seats.")}
    end
  end

  @impl true
    def handle_event("show_event_details", %{"event-id" => id}, socket) do
      event = Context.get_event!(id)
     {:noreply, assign(socket, %{selected_event: event, live_action: :show})}

    end


  @impl true
  def handle_info({:party_updated, updated_event}, socket) do
    updated_events =
      Enum.map(socket.assigns.events, fn e ->
        if e.id == updated_event.id, do: updated_event, else: e
      end)

    {:noreply, assign(socket, :events, updated_events)}
  end

  @impl true
    def handle_info(:reload_events, socket) do
      # Fetch the latest events from the GenServer
      {:noreply, assign(socket, :events, Server.get_party())}
    end


end
