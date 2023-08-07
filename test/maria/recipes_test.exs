defmodule Maria.RecipesTest do
  use Maria.DataCase

  alias Maria.Recipes

  describe "recipes" do
    alias Maria.Recipes.Recipe

    import Maria.RecipesFixtures

    @invalid_attrs %{image: nil, description: nil, directions: nil, ingredients: nil, likes: nil, mins: nil, tags: nil, title: nil, user_id: nil, is_draft: nil}

    test "list_recipes/1 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes(false) == [recipe]
    end

    test "list_recipes/1 returns all recipes that are not in a draft state" do
      _recipe = recipe_fixture(%{is_draft: true})
      assert Recipes.list_recipes(true) == []
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      image = %Phoenix.LiveView.UploadEntry {client_name: "cover.png"}
      valid_attrs = %{image: image, description: "some description", directions: "some directions", ingredients: "option1, option2", mins: "4h", link: "link", tags: "option1, option2", title: "some title", yield: 1}

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe("some-title", valid_attrs)
      assert recipe.image =~ "some-title"
      assert recipe.description == "some description"
      assert recipe.directions == "some directions"
      assert recipe.ingredients == "option1, option2"
      assert recipe.yield == 1
      assert recipe.mins == "4h"
      assert recipe.link == "link"
      assert recipe.tags == "option1, option2"
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with valid draft data creates a recipe" do
      valid_attrs = %{ title: "some title", is_draft: true}

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe("some-title", valid_attrs)
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe("", @invalid_attrs)
    end

    test "update_recipe/3 with valid data updates the recipe" do
      recipe = recipe_fixture()
      image = %Phoenix.LiveView.UploadEntry {client_name: "cover.png"}
      update_attrs = %{image: image, description: "some updated description", directions: "some updated directions", ingredients: "option1", yield: 1, mins: "4h", link: "updated link", tags: "option1", title: "some updated title"}

      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, "some-updated-title",  update_attrs)
      assert recipe.image =~ "some-updated-title"
      assert recipe.description == "some updated description"
      assert recipe.directions == "some updated directions"
      assert recipe.ingredients == "option1"
      assert recipe.yield == 1
      assert recipe.mins == "4h"
      assert recipe.link == "updated link"
      assert recipe.tags == "option1"
      assert recipe.title == "some updated title"
    end

    test "update_recipe/3 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, "socket", @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end
end
