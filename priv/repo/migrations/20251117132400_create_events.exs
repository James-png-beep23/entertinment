defmodule Party1.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :location, :string
      add :price, :decimal
      add :capacity, :integer
      add :number_of_attendees, :integer, default: 0



      timestamps(type: :utc_datetime)
    end
  end
end
