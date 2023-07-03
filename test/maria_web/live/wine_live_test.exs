defmodule MariaWeb.WineLiveTest do
  use MariaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Maria.DrinkingFixtures
  import Maria.AccountsFixtures
require Logger
  @create_attrs %{alcohol: 120.5, body: "light", buy_link: "some buy_link", color: "white", country: "some country", description: "some description", food_pairig: "some food_pairig", grapes: "some grapes", image: "some image", is_draft: true, is_featured: true, name: "some name", price: 120.5, producer: "some producer", rating: 42, region: "some region", sweetness: "sweet", vintage: 42}
  @update_attrs %{alcohol: 456.7, body: "medium", buy_link: "some updated buy_link", color: "orange", country: "some updated country", description: "some updated description", food_pairig: "some updated food_pairig", grapes: "some updated grapes", image: "some updated image", is_draft: false, is_featured: false, name: "some updated name", price: 456.7, producer: "some updated producer", rating: 43, region: "some updated region", sweetness: "medium", vintage: 43}
  @invalid_attrs %{alcohol: nil, body: "very light", buy_link: nil, color: "white", country: nil, description: nil, food_pairig: nil, grapes: nil, image: nil, is_draft: false, is_featured: false, name: nil, price: nil, producer: nil, rating: nil, region: nil, sweetness: "dry", vintage: nil}

  defp create_wine(_) do
    wine = wine_fixture()

    %{wine: wine}
  end

  describe "Index" do
    setup [:create_wine]

    test "lists all wines", %{conn: conn, wine: wine} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/wines")

      assert html =~ "Listing Wines"
      assert html =~ wine.color
    end

    test "saves new wine", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/wines")

      assert index_live |> element("a", "New Wine") |> render_click() =~
               "New Wine"

      assert_patch(index_live, ~p"/wines/new")

      assert index_live
             |> form("#wine-form", wine: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#wine-form", wine: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/wines")

      html = render(index_live)
      assert html =~ "Wine created successfully"
      assert html =~ "white"
    end

    test "updates wine in listing", %{conn: conn, wine: wine} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(wine.user)
        |> live(~p"/wines")

      assert index_live |> element("#wines-#{wine.id} a", "Edit") |> render_click() =~
               "Edit #{wine.name}"

      assert_patch(index_live, ~p"/wines/#{wine}/edit")

      assert index_live
             |> form("#wine-form", wine: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#wine-form", wine: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/wines")

      html = render(index_live)
      assert html =~ "Wine updated successfully"
      assert html =~ "medium"
    end

    test "deletes wine in listing", %{conn: conn, wine: wine} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(wine.user)
        |> live( ~p"/wines")

      assert index_live |> element("#wines-#{wine.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#wines-#{wine.id}")
    end
  end

  describe "Show" do
    setup [:create_wine]

    test "displays wine", %{conn: conn, wine: wine} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(wine.user)
        |> live(~p"/wines/#{wine}")

      assert html =~ "#{wine.name}"
      assert html =~ wine.body
    end

    test "updates wine within modal", %{conn: conn, wine: wine} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(wine.user)
        |> live(~p"/wines/#{wine}")

      assert show_live |> element(".wine-actions a", "Edit") |> render_click() =~
               "Edit"

      assert_patch(show_live, ~p"/wines/#{wine}/show/edit")

      assert show_live
             |> form("#wine-form", wine: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#wine-form", wine: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/wines/#{wine}")

      html = render(show_live)
      assert html =~ "Wine updated successfully"
      assert html =~ "medium"
    end
  end
end
