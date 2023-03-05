defmodule Maria.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Maria.Recipes` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        cover: "cover",
        description: "some description",
        directions: "some directions",
        ingredients: ["option1", "option2"],
        likes: 42,
        mins: 42,
        tags: ["option1", "option2"],
        title: "some title"
      })
      |> Maria.Recipes.create_recipe()

    recipe
  end
end
