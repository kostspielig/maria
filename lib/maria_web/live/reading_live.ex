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
        next_link="https://www.goodreads.com/kostspielig"
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
      <div class="font-sans odd:bg-skin-lighter odd:text-black">
      <div class="px-6 py-8 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl">
        <h1 class="text-2xl font-bold"><%= podcast.title %> </h1>
        <h2 class="mt-2 text-base font-normal"><%= podcast.subtitle %> </h2>
        <.carousel_items
          items={podcast.entries}
          next_link={podcast.link}
        />
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
        <h2 class="mt-2 text-base font-normal"><%= newsletter.subtitle %> </h2>
        <.carousel_items
          items={newsletter.entries}
          next_link={newsletter.link}
        />
      </div>
      </div>
      <% end %>
    </section>

    <section id="youtube" class="bg-neutral text-black">
      <h1 class="px-6 pt-10 font-head font-bold text-2xl  mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl"> Youtube </h1>
      <%= for yc <- @youtube do %>
      <div class="font-sans odd:bg-white odd:text-black">
      <div class="px-6 py-8 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-6xl">
        <h1 class="text-2xl font-bold"><%= yc.title %> </h1>
    <!--  <iframe width="320" height="255" allow="fullscreen" frameBorder="0" src={"#{String.replace(e.link, "https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")}"}></iframe> -->
        <.carousel_items
          items={yc.entries}
          next_link={yc.link}
        />
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
    podcast = ["https://rss.art19.com/the-taste-podcast", "https://feeds.megaphone.fm/GLT3714323852"] # "https://changelog.com/master/feed"
    feeds = get_feeds(podcast)

    Enum.map(feeds, fn(feed) ->
      %{
        title: feed.title,
        subtitle: feed.subtitle,
        link: feed.link,
        entries: Enum.map(feed.entries, fn item ->
          %{title: item.title, image: item.image, link: item.enclosure.url, alt_img: feed.title}
        end)
  } end)
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
    feeds = get_feeds(newsletters)

    Enum.map(feeds, fn(feed) ->
      %{
        title: feed.title,
        subtitle: feed.subtitle,
        link: feed.link,
        entries: Enum.map(feed.entries, fn item ->
          %{title: item.title, image: item.enclosure.url, link: item.link, alt_img: feed.title}
        end)
  } end)
  end


  def get_youtube() do
    youtubes = ["https://www.youtube.com/feeds/videos.xml?channel_id=UCJATm9C8Xp8gMBKDIKPnvog",
                "https://www.youtube.com/feeds/videos.xml?channel_id=UCsBjURrPoezykLs9EqgamOA",
                "https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q",
                "https://www.youtube.com/feeds/videos.xml?channel_id=UCaLfMkkHhSA_LaCta0BzyhQ",
                "https://www.youtube.com/feeds/videos.xml?channel_id=UCh8gHdtzO2tXd593_bjErWg",
                "https://www.youtube.com/feeds/videos.xml?channel_id=UCcW03MCvL7-Apt_XmPa07EA"]
    feeds = get_feeds(youtubes)

    Enum.map(feeds, fn(feed) ->
      %{
        title: feed.title,
        subtitle: feed.subtitle,
        link: String.replace(feed.link, "http://www.youtube.com/feeds/videos.xml?channel_id=", "https://youtube.com/channel/"),
        entries: Enum.map(feed.entries, fn item ->
          %{title: item.title, image: String.replace(item.link, "https://www.youtube.com/watch?v=", "https://img.youtube.com/vi/") <> "/0.jpg", link: item.link}
        end)
  } end)
  end
end
