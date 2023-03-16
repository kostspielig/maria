defmodule Maria.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Maria.Recipes` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    user = Maria.AccountsFixtures.user_fixture()

    cover = %Plug.Upload{content_type: "image/png", filename: "cover.png", path: "/tmp/plug"}
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        cover: cover,
        description: "some description",
        directions: "some directions",
        ingredients: ["option1", "option2"],
        likes: 42,
        mins: 42,
        tags: ["option1", "option2"],
        title: "some title",
        user_id: user.id,
        editor_id: user.id
      })
      |> Maria.Recipes.create_recipe()

    recipe |> Maria.Repo.preload(:user) |> Maria.Repo.preload(:editor)
  end
end
