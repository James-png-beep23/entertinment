defmodule Party1Web.EventLive.FormComponent do
  use Party1Web, :live_component



  alias Party1.Context


  @topic "party_updates"

  @impl true
  def update(%{event: event} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1
     )
     |> assign_new(:form, fn ->
       to_form(Context.change_event(event))
     end)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Context.change_event(socket.assigns.event, event_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
      uploaded =
        consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
          dest = Path.join("priv/static/uploads", Path.basename(path))
          File.mkdir_p!(Path.dirname(dest))  # <-- ensure folder exists
          File.cp!(path, dest)
          "/uploads/#{Path.basename(dest)}"  # <-- store this in DB
        end)


    # Add image_url to params if an image was uploaded
    event_params =
      case uploaded do
        [image_url] -> Map.put(event_params, "image_url", image_url)
        _ -> event_params
      end

    save_event(socket, socket.assigns.action, event_params)
  end



  defp save_event(socket, :edit, event_params) do
    case Context.update_event(socket.assigns.event, event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})
        Phoenix.PubSub.broadcast(Party1.PubSub, @topic, :reload_events)

        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_event(socket, :new, event_params) do
    case Context.create_event(event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})
        Phoenix.PubSub.broadcast(Party1.PubSub, @topic, :reload_events)

        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
