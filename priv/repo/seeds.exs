# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Penta.Repo.insert!(%Penta.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Penta.Catalog

all_skus = Catalog.list_products() |> Enum.map(fn p -> p.sku end)

products = [
  %{
    name: "Chess",
    description: "The classic strategy game",
    sku: 5_678_910,
    unit_price: 10.00
  },
  %{
    name: "Tic-Tac-Toe",
    description: "The game of Xs and Os",
    sku: 11_121_314,
    unit_price: 3.00
  },
  %{
    name: "Table Tennis",
    description: "Bat the ball back and forth. Don't miss!",
    sku: 15_22_324,
    unit_price: 12.00
  },
  %{
    name: "Candy Smush",
    description: "A candy-themed puzzle game",
    sku: 50_982_761,
    unit_price: 3.0
  },
  %{
    name: "Battleship",
    sku: 89_101_112,
    unit_price: 10.00,
    description: "Sink your opponent!"
  }
]

products
|> Enum.filter(fn product -> product.sku not in all_skus end)
|> Enum.each(fn product -> Catalog.create_product(product) end)
