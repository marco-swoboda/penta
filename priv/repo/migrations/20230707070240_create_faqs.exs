defmodule Penta.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :question, :string, null: false
      add :answer, :string, null: false
      add :vote_count, :integer, null: false, default: 0

      timestamps()
    end
  end
end
