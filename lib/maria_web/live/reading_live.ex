defmodule MariaWeb.ReadingLive do
  use MariaWeb, :live_view


  def mount(_params, _session, socket) do

    socket = assign(socket,
      newsletter: get_newsletters(),
      goodreads: get_books(),
      podcast: get_podcasts(),
      youtube: get_youtube()
    )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section id="goodreads" class="border-brand border-b pb-8">
      <h1 class="uppercase font-bold font-sans text-xl text-blk"> Books </h1>
      <div class="overflow-x-auto flex">
      <%= for book <- @goodreads do %>
        <div class="flex-none px-3 py-6 first:pl-0 last:pr-6">
          <a href={"#{book["link"]}"} target="_blank">
          <img class="max-h-80" src={"#{Regex.replace(~r/_\w+_/u, book["src"], "")|> String.replace("..jpg", ".jpg")}"}>
          <div class="block w-40 mt-4">
          <!--<div class="inline leading-6 font-serif font-bold text-blk text-xl"><%= book["title"] %></div>-->
          </div>
          </a>
        </div>
      <% end %>
      </div>
    </section>

    <section id="podcast" class="mt-10 border-brand border-b pb-8">
      <h1 class="uppercase font-bold font-sans text-xl text-blk"> Podcasts </h1>
      <div class="font-sans mt-10">
        <h1 class="text-3xl font-bold"><%= @podcast.title %> </h1>
        <h2 class="mt-2 text-base font-normal"><%= @podcast.subtitle %> </h2>
        <div class="overflow-x-auto flex">
          <%= for e <- @podcast.entries do %>
            <div class="flex-none py-6 px-3 first:pl-0 last:pr-6">
              <a href={"#{e.enclosure.url}"} target="_blank">
                <img class="max-h-80" src={"#{e.image}"}>
                <div class="w-80 block mt-4 font-serif font-bold text-blk text-xl hover:text-blood"><%= e.title %></div>
              </a>
            </div>
          <% end %>
        </div>
      </div>
    </section>

    <section id="newsletter" class="mt-10 border-brand border-b pb-8">
      <h1 class="uppercase font-bold font-sans text-xl text-blk"> Newsletters </h1>
      <%= for newsletter <- @newsletter do %>
      <div class="font-sans mt-10">
        <h1 class="text-3xl font-bold"><%= newsletter.title %> </h1>
        <h2 class="mt-2 text-base font-normal"><%= newsletter.summary %> </h2>
        <div class="overflow-x-auto flex">
          <%= for e <- newsletter.entries do %>
            <div class="flex-none py-6 px-3 first:pl-0 last:pr-6">
              <a href={"#{e.link}"} target="_blank">
                <img class="max-h-80" src={"#{e.enclosure.url}"}>
                <div class="w-80 block mt-4 font-serif font-bold text-blood text-xl hover:text-blood"><%= e.title %></div>
              </a>
            </div>
          <% end %>
        </div>
      </div>
      <% end %>
    </section>

    <section id="youtube" class="mt-10">
      <h1 class="uppercase font-sans font-bold text-xl text-blk"> Youtube </h1>
      <%= for yc <- @youtube do %>
      <div class="font-sans mt-10">
        <h1 class="text-3xl font-bold"><%= yc.title %> </h1>
        <div class="overflow-x-auto flex">
          <%= for e <- yc.entries do %>
          <div class="flex-none py-6 px-3 first:pl-6 last:pr-6">
            <!--  <iframe width="320" height="255" allow="fullscreen" frameBorder="0" src={"#{String.replace(e.link, "https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")}"}></iframe> -->
            <a href={"#{e.link}"} target="_blank">
              <img class="max-h-80" src={"#{String.replace(e.link, "https://www.youtube.com/watch?v=", "https://img.youtube.com/vi/") <> "/0.jpg"}"}>
              <div class="w-80 block mt-4 font-serif font-bold text-brand text-xl hover:text-blood"><%= e.title %></div>
            </a>
          </div>
          <% end %>
        </div>
      </div>
      <% end %>
    </section>

    """
  end


# To be defined as private!

  def get_feed(url) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    {:ok, feed, _} = FeederEx.parse(body)
    feed
  end

  def get_feeds(urls) do
    Enum.map(urls, &(get_feed(&1)))
  end

  def get_podcasts() do
    podcast = ["https://feeds.megaphone.fm/darknetdiaries"]
    get_feed(List.first(podcast))
  end

  def get_books() do
    feed = get_feed("https://www.goodreads.com/user/updates_rss/50420888")
    Enum.filter(feed.entries, &(String.contains?(&1.title, "currently reading")))
    |>
    Enum.map(
      fn(x) ->
        [{_, imgs, _}] = Floki.find(x.summary, "img")
        [{"link", x.link } | Enum.filter(imgs, &(elem(&1,0) == "title" || elem(&1,0) == "src"))]
        |> Enum.reduce(%{}, &(Map.put(&2, elem(&1,0), elem(&1,1))))
      end
    )  |> Enum.filter(&(Map.has_key?(&1, "title")))
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
