defmodule Maria.DrinkingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Maria.Drinking` context.
  """

  @doc """
  Generate a wine.
  """
  def wine_fixture(attrs \\ %{}) do
    user = Maria.AccountsFixtures.user_fixture()

    {:ok, wine} =
      attrs
      |> Enum.into(%{
        alcohol: 120.5,
        body: "some body",
        buy_link: "some buy_link",
        color: "some color",
        country: "some country",
        description: "some description",
        food_pairig: "some food_pairig",
        grapes: "some grapes",
        image: "some image",
        is_draft: true,
        is_featured: true,
        title: "some name",
        price: 120.5,
        producer: "some producer",
        rating: 42,
        region: "some region",
        sweetness: "some sweetness",
        vintage: 42,
        user_id: user.id,
        editor_id: user.id
      })
      |> Maria.Drinking.create_wine()

    wine |> Maria.Repo.preload(:user) |> Maria.Repo.preload(:editor)
  end
end
