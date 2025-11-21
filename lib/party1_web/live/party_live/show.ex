defmodule Party1Web.PartyLive.Show do
  use Party1Web, :live_view

  alias Party1.Context
  alias Party1.Server
  # alias Party1.Context.Event

  @impl true
  def mount(_params, _session, socket) do

     current_user = socket.assigns[:current_user]
    socket =
      socket
      # |> assign(:event, nil)
      |> assign(:price, 0)
      |> assign(:current_user, current_user)
    {:ok, socket}
  end


  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply, assign(socket, :event, Context.get_event!(id))}
  end

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
  def handle_event("get_price", %{"event_id" => event_id, "number_of_attendees" => number_of_attendees}, socket) do
    event_id = String.to_integer(event_id)
    number_of_attendees = String.to_integer(number_of_attendees)

    price = Server.get_price(event_id, number_of_attendees)

      {:noreply,
       socket
       |> put_flash(:info, "The total price for #{number_of_attendees} attendees is Ksh#{price}")
       |> assign(:price, price)}

  end

  @impl true
    def handle_event("show_event_details", %{"event-id" => id}, socket) do
      event = Context.get_event!(id)
     {:noreply, assign(socket, %{selected_event: event, live_action: :show})}

    end
end
