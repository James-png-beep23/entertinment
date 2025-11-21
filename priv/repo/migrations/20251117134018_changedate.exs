defmodule Party1.Repo.Migrations.Changedate do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :start_date, :date
      modify :end_date, :date
    end

  end
end
