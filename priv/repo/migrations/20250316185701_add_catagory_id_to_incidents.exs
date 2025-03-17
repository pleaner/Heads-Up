defmodule HeadsUp.Repo.Migrations.AddCatagoryIdToIncidents do
  use Ecto.Migration

  def change do
    alter table(:incidents) do
      add :category_id, references(:categories)
    end

    create index(:incidents, [:category_id])
  end
end
