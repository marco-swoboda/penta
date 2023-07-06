defmodule Penta.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :unit_price, :decimal, precision: 15, scale: 6, null: false
      add :sku, :integer

      timestamps()
    end

    create unique_index(:products, [:sku])
  end
end
