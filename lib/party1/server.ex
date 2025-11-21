defmodule Party1.Server do
  use GenServer

  alias Party1.Context

  @topic "party_updates"

  def start_link(opt \\ %{}) do
    GenServer.start_link(__MODULE__, opt, name: __MODULE__)
  end

  def get_party do
    GenServer.call(__MODULE__, :get_party)
  end

  def get_price(evend_id, number_of_attendees) do
    GenServer.call(__MODULE__, {:get_price, evend_id, number_of_attendees})
  end

  def get_remaining_seats(event_id, number_of_attendees) do
    GenServer.call(__MODULE__, {:get_remaining_seats, event_id, number_of_attendees})
  end




  def init(_opts) do
    Phoenix.PubSub.subscribe(Party1.PubSub, @topic)
    party = Context.list_events()
    {:ok, %{party: party}}
  end

  def handle_info(:reload_events, state) do
  events = Context.list_events()
  {:noreply, %{state | party: events}}
end


  def handle_call(:get_party, _from, state) do
    {:reply, state.party, state}
  end

    def handle_call({:get_remaining_seats, event_id, number_of_attendees}, _from, state) do
      event = Context.get_event!(event_id)
      capacity = event.capacity
      remaining_seats = capacity - number_of_attendees

    if remaining_seats >= 0 do
      case Context.update_event(event, %{capacity: remaining_seats}) do
        {:ok, updated_event} ->
          # Phoenix.PubSub.broadcast(Party1.PubSub, @topic, :reload_events)
          updated_party =
            Enum.map(state.party, fn e ->
              if e.id == updated_event.id, do: updated_event, else: e
            end)

            Phoenix.PubSub.broadcast(Party1.PubSub, @topic, {:party_updated, updated_event})

          {:reply, remaining_seats, %{state | party: updated_party}}

        {:error, _changeset} ->
          {:reply, :error, state}
      end

      else
        {:reply, remaining_seats, state}
    end
    end

    def handle_call({:get_price, event_id, number_of_attendees}, _from, state) do
        event = Context.get_event!(event_id)
        total_price =
          event.price
          |> Decimal.mult(number_of_attendees)
          # |> Decimal.to_float()

        {:reply, total_price, state}
    end



end
