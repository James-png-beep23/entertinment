defmodule Party1.ContextTest do
  use Party1.DataCase

  alias Party1.Context

  describe "events" do
    alias Party1.Context.Event

    import Party1.ContextFixtures

    @invalid_attrs %{title: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Context.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Context.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Event{} = event} = Context.create_event(valid_attrs)
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Context.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Event{} = event} = Context.update_event(event, update_attrs)
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Context.update_event(event, @invalid_attrs)
      assert event == Context.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Context.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Context.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Context.change_event(event)
    end
  end
end
