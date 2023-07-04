defmodule Penta.Repo.Migrations.AddUsername do
  use Ecto.Migration

  def change do
    alter(table(:users)) do
      add :username, :string, null: true
    end
  end
end
