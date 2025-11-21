defmodule Party1Web.EventLive.Index do
  use Party1Web, :live_view

  alias Party1.Context
  alias Party1.Context.Event

  

  @topic "party_updates"


  @impl true
 def mount(_params, session, socket) do
  # get the current user if logged in, otherwise nil
  current_user =
    case Map.get(session, "user_token") do
      nil -> nil
      token -> Party1.Account.get_user_by_session_token(token)
    end

  {:ok,
   socket
   |> assign(:current_user, current_user)
   |> stream(:events, Context.list_events())}
end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Context.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({Party1Web.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Context.get_event!(id)
    {:ok, _} = Context.delete_event(event)
    Phoenix.PubSub.broadcast(Party1.PubSub, @topic, :reload_events)

    {:noreply, stream_delete(socket, :events, event)}
  end
end
