defmodule Maria.DrinkingTest do
  use Maria.DataCase

  alias Maria.Drinking

  describe "wines" do
    alias Maria.Drinking.Wine

    import Maria.DrinkingFixtures

    @invalid_attrs %{alcohol: nil, body: nil, buy_link: nil, color: nil, country: nil, description: nil, food_pairig: nil, grapes: nil, image: nil, is_draft: nil, is_featured: nil, name: nil, price: nil, producer: nil, rating: nil, region: nil, sweetness: nil, vintage: nil}

    test "list_wines/0 returns all wines" do
      wine = wine_fixture()
      assert Drinking.list_wines() == [wine]
    end

    test "get_wine!/1 returns the wine with given id" do
      wine = wine_fixture()
      assert Drinking.get_wine!(wine.id) == wine
    end

    test "create_wine/1 with valid data creates a wine" do
      valid_attrs = %{alcohol: 120.5, body: "some body", buy_link: "some buy_link", color: "some color", country: "some country", description: "some description", food_pairig: "some food_pairig", grapes: "some grapes", image: "some image", is_draft: true, is_featured: true, name: "some name", price: 120.5, producer: "some producer", rating: 42, region: "some region", sweetness: "some sweetness", vintage: 42}

      assert {:ok, %Wine{} = wine} = Drinking.create_wine(valid_attrs)
      assert wine.alcohol == 120.5
      assert wine.body == "some body"
      assert wine.buy_link == "some buy_link"
      assert wine.color == "some color"
      assert wine.country == "some country"
      assert wine.description == "some description"
      assert wine.food_pairig == "some food_pairig"
      assert wine.grapes == "some grapes"
      assert wine.image == "some image"
      assert wine.is_draft == true
      assert wine.is_featured == true
      assert wine.name == "some name"
      assert wine.price == 120.5
      assert wine.producer == "some producer"
      assert wine.rating == 42
      assert wine.region == "some region"
      assert wine.sweetness == "some sweetness"
      assert wine.vintage == 42
    end

    test "create_wine/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Drinking.create_wine(@invalid_attrs)
    end

    test "update_wine/2 with valid data updates the wine" do
      wine = wine_fixture()
      update_attrs = %{alcohol: 456.7, body: "some updated body", buy_link: "some updated buy_link", color: "some updated color", country: "some updated country", description: "some updated description", food_pairig: "some updated food_pairig", grapes: "some updated grapes", image: "some updated image", is_draft: false, is_featured: false, name: "some updated name", price: 456.7, producer: "some updated producer", rating: 43, region: "some updated region", sweetness: "some updated sweetness", vintage: 43}

      assert {:ok, %Wine{} = wine} = Drinking.update_wine(wine, update_attrs)
      assert wine.alcohol == 456.7
      assert wine.body == "some updated body"
      assert wine.buy_link == "some updated buy_link"
      assert wine.color == "some updated color"
      assert wine.country == "some updated country"
      assert wine.description == "some updated description"
      assert wine.food_pairig == "some updated food_pairig"
      assert wine.grapes == "some updated grapes"
      assert wine.image == "some updated image"
      assert wine.is_draft == false
      assert wine.is_featured == false
      assert wine.name == "some updated name"
      assert wine.price == 456.7
      assert wine.producer == "some updated producer"
      assert wine.rating == 43
      assert wine.region == "some updated region"
      assert wine.sweetness == "some updated sweetness"
      assert wine.vintage == 43
    end

    test "update_wine/2 with invalid data returns error changeset" do
      wine = wine_fixture()
      assert {:error, %Ecto.Changeset{}} = Drinking.update_wine(wine, @invalid_attrs)
      assert wine == Drinking.get_wine!(wine.id)
    end

    test "delete_wine/1 deletes the wine" do
      wine = wine_fixture()
      assert {:ok, %Wine{}} = Drinking.delete_wine(wine)
      assert_raise Ecto.NoResultsError, fn -> Drinking.get_wine!(wine.id) end
    end

    test "change_wine/1 returns a wine changeset" do
      wine = wine_fixture()
      assert %Ecto.Changeset{} = Drinking.change_wine(wine)
    end
  end
end
