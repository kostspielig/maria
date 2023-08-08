defmodule MariaWeb.ReadingLive do
  use MariaWeb, :live_view_basic


  def mount(_params, _session, socket) do
    socket = assign(socket,
      page_title: "Reading",
      newsletter: get_newsletters(),
      goodreads: get_books(),
      podcasts: get_podcasts(),
      youtube: get_youtube()
    )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section id="goodreads" class="">
      <.carousel
        title="Books"
        title_link="https://www.goodreads.com/kostspielig"
        subtitle="Must-read list of Books"
        items={@goodreads}
        img_height={80}
        color="black"
        class="px-6 py-10 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl"
      />
    </section>

    <section id="podcast" class="bg-brand text-white">
      <h1 class="px-6 pt-10 font-head text-2xl font-bold mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl"> Podcasts </h1>
      <%= for podcast <- @podcasts do %>
      <div class="font-sans odd:bg-white odd:text-black">
      <div class="px-6 py-8 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl">

        <h1 class="text-2xl font-bold"><%= podcast.title %> </h1>
        <h2 class="mt-2 text-base font-normal"><%= podcast.subtitle %> </h2>
        <div class="overflow-x-auto flex">
          <%= for e <- podcast.entries do %>
            <div class="flex-none py-6 px-3 first:pl-0 last:pr-6">
              <a href={"#{e.link}"} target="_blank">
                <img class="max-h-60 mx-auto" src={"#{e.image}"}>
                <div class="block w-60 mt-4">
                  <div class="inline leading-6 font-serif font-semibold text-lg hover:bg-blood"><%= e.title %></div>
                </div>
              </a>
            </div>
          <% end %>
        </div>
      </div>
      </div>
      <% end %>
    </section>

    <section id="newsletter" class="text-blood">
      <h1 class="px-6 pt-10 font-head text-2xl font-bold mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl"> Newsletters </h1>
      <%= for newsletter <- @newsletter do %>
      <div class="font-sans odd:bg-blood odd:bg-opacity-10">
      <div class="px-6 py-8 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl">
        <h1 class="text-2xl font-bold"><%= newsletter.title %> </h1>
        <h2 class="mt-2 text-base font-normal"><%= newsletter.summary %> </h2>
        <div class="overflow-x-auto flex">
          <%= for e <- newsletter.entries do %>
            <div class="flex-none py-6 px-3 first:pl-0 last:pr-6">
              <a href={"#{e.link}"} target="_blank">
              <img class="max-h-60 mx-auto" src={"#{e.enclosure.url}"}>
              <div class="block w-60 mt-4">
                <div class="inline leading-6 font-serif font-semibold text-lg hover:bg-blood hover:text-white"><%= e.title %></div>
               </div>
              </a>
            </div>
          <% end %>
        </div>
      </div>
      </div>
      <% end %>
    </section>

    <section id="youtube" class="bg-neutral text-black">
      <h1 class="px-6 pt-10 font-head font-bold text-2xl  mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl"> Youtube </h1>
      <%= for yc <- @youtube do %>
      <div class="font-sans odd:bg-black odd:bg-opacity-10">
      <div class="px-6 py-8 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl">
        <h1 class="text-2xl font-bold"><%= yc.title %> </h1>
        <div class="overflow-x-auto flex">
          <%= for e <- yc.entries do %>
          <div class="flex-none py-6 px-3 first:pl-6 last:pr-6">
            <!--  <iframe width="320" height="255" allow="fullscreen" frameBorder="0" src={"#{String.replace(e.link, "https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")}"}></iframe> -->
            <a class="" href={"#{e.link}"} target="_blank">
              <img class="max-h-52 mx-auto" src={"#{String.replace(e.link, "https://www.youtube.com/watch?v=", "https://img.youtube.com/vi/") <> "/0.jpg"}"}>
                <div class="block w-48 mt-4">
                  <div class="inline leading-6 font-serif font-semibold text-lg hover:bg-brand hover:text-white"><%= e.title %></div>
                </div>
            </a>
          </div>
          <% end %>
        </div>
      </div>
      </div>
      <% end %>
    </section>

    """
  end


# To be defined as private!

  def get_feed(url) do
    {:ok, %HTTPoison.Response{body: body}} = MariaWeb.Cache.get(url)
    {:ok, feed, _} = FeederEx.parse(body)

    Map.update(feed, :entries, nil, fn current_value ->
      Enum.take(current_value, 5)
    end)
  end

  def get_feeds(urls) do
    Enum.map(urls, &(get_feed(&1)))
  end

  def get_podcasts() do
    podcast = ["https://feeds.megaphone.fm/darknetdiaries"] # "https://changelog.com/master/feed"
    feed = get_feed(List.first(podcast))

    [%{
      title: feed.title,
      subtitle: feed.subtitle,
      entries: Enum.map(feed.entries, fn item ->
        %{title: item.title, image: item.image, link: item.enclosure.url}
      end)
     }]
  end

  def get_books() do
    feed = get_feed("https://www.goodreads.com/user/updates_rss/50420888")
    parsed_books = Enum.filter(feed.entries, &(!String.contains?(&1.title, "Maria liked")))
    |>
    Enum.map(
      fn(x) ->
        [{_, imgs, _}] = Floki.find(x.summary, "img")
        [{"link", x.link } | Enum.filter(imgs, &(elem(&1,0) == "title" || elem(&1,0) == "src"))]
        |> Enum.reduce(%{}, &(Map.put(&2, elem(&1,0), elem(&1,1))))
      end
    )  |> Enum.filter(&(Map.has_key?(&1, "title")))

    Enum.map(parsed_books, fn book ->
      %{
        title: nil,
        image: Regex.replace(~r/_\w+_/u, book["src"], "") |> String.replace("..jpg", ".jpg"),
        link: book["link"]}
      end)
  end

  def get_newsletters() do
    newsletters = ["https://blog.bytebytego.com/feed", "https://anewsletter.alisoneroman.com/feed"]
    get_feeds(newsletters)
  end


  def get_youtube() do
    youtubes = ["https://www.youtube.com/feeds/videos.xml?channel_id=UCsBjURrPoezykLs9EqgamOA", "https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q"]
    get_feeds(youtubes)
  end
end
