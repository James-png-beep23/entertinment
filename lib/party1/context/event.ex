defmodule Party1.Context.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date
    field :location, :string
    field :price, :decimal
    field :capacity, :integer
    field :image_url, :string
    field :number_of_attendees, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :start_date, :end_date, :location, :price, :capacity, :number_of_attendees, :image_url])
    |> validate_required([:title, :description, :start_date, :end_date, :location, :price, :capacity, :number_of_attendees])
  end
end
#
