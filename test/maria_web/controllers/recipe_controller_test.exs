defmodule MariaWeb.RecipeControllerTest do
  use MariaWeb.ConnCase

  import Maria.RecipesFixtures
  @create_attrs %{cover: %Plug.Upload {filename: "cover", path: "/some"}, description: "some description", directions: "some directions", ingredients: "option1, option 2", likes: 42, mins: 42, tags: "option1, option2", title: "some title"}
  @update_attrs %{cover: %Plug.Upload {filename: "updated cover", path: "/some"},  description: "some updated description", directions: "some updated directions", ingredients: "option1", likes: 43, mins: 43, tags: "option1", title: "some updated title"}
  @invalid_attrs %{cover: %Plug.Upload {filename: "", path: "/some"}, description: nil, directions: nil, ingredients: "", likes: nil, mins: nil, tags: "", title: nil}

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, ~p"/recipes")
      assert html_response(conn, 200) =~ "Listing Recipes"
    end
  end

  describe "new recipe" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/recipes/new")
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "create recipe" do
    @tag :skip
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/recipes", recipe: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/recipes/#{id}"

      conn = get(conn, ~p"/recipes/#{id}")
      assert html_response(conn, 200) =~ "Recipe #{id}"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/recipes", recipe: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "edit recipe" do
    setup [:create_recipe]

    @tag :skip
    test "renders form for editing chosen recipe", %{conn: conn, recipe: recipe} do
      conn = get(conn, ~p"/recipes/#{recipe}/edit")
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, recipe: recipe} do
      conn = put(conn, ~p"/recipes/#{recipe}", recipe: @update_attrs)
      assert redirected_to(conn) == ~p"/recipes/#{recipe}"

      conn = get(conn, ~p"/recipes/#{recipe}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, ~p"/recipes/#{recipe}", recipe: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete(conn, ~p"/recipes/#{recipe}")
      assert redirected_to(conn) == ~p"/recipes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/recipes/#{recipe}")
      end
    end
  end

  defp create_recipe(_) do
    recipe = recipe_fixture()
    %{recipe: recipe}
  end
end
