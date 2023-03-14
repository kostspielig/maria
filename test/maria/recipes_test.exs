defmodule Maria.RecipesTest do
  use Maria.DataCase

  alias Maria.Recipes

  describe "recipes" do
    alias Maria.Recipes.Recipe

    import Maria.RecipesFixtures

    @invalid_attrs %{cover: nil, description: nil, directions: nil, ingredients: nil, likes: nil, mins: nil, tags: nil, title: nil, user_id: nil}

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      valid_attrs = %{cover: "cover", description: "some description", directions: "some directions", ingredients: ["option1", "option2"], likes: 42, mins: 42, tags: ["option1", "option2"], title: "some title"}

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(valid_attrs)
      assert recipe.cover == "cover"
      assert recipe.description == "some description"
      assert recipe.directions == "some directions"
      assert recipe.ingredients == ["option1", "option2"]
      assert recipe.likes == 42
      assert recipe.mins == 42
      assert recipe.tags == ["option1", "option2"]
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      update_attrs = %{cover: "updated cover", description: "some updated description", directions: "some updated directions", ingredients: ["option1"], likes: 43, mins: 43, tags: ["option1"], title: "some updated title"}

      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, update_attrs)
      assert recipe.cover == "updated cover"
      assert recipe.description == "some updated description"
      assert recipe.directions == "some updated directions"
      assert recipe.ingredients == ["option1"]
      assert recipe.likes == 43
      assert recipe.mins == 43
      assert recipe.tags == ["option1"]
      assert recipe.title == "some updated title"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
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
