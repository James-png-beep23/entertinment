defmodule Party1.ContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Party1.Context` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Party1.Context.create_event()

    event
  end
end
