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

    image = %Phoenix.LiveView.UploadEntry {client_name: "cover.png"}
    new_attrs =
      attrs
      |> Enum.into(%{
        image: image,
        description: "some description",
        directions: "some directions",
        ingredients: "option1, option2",
        yield: 1,
        mins: "4h",
        tags: "option1, option2",
        title: "some title",
        is_draft: false,
        user_id: user.id,
        editor_id: user.id})

    {:ok, recipe} = Maria.Recipes.create_recipe("", new_attrs)

    recipe |> Maria.Repo.preload(:user) |> Maria.Repo.preload(:editor)
  end
end
