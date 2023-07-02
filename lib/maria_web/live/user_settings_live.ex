defmodule MariaWeb.UserSettingsLive do
  use MariaWeb, :live_view

  alias Maria.Accounts
  alias Maria.Recipes

  def render(assigns) do
    ~H"""
    <script src="https://cdn.ckeditor.com/ckeditor5/37.0.1/classic/ckeditor.js"></script>
    <div class="text-base font-head leading-8 text-zinc-800">👏 <%= @current_username %>

    </div>
    <.header class="mt-12">My Recipes
      <:actions>
        <.link href={~p"/recipes"}>
          <.button>See All</.button>
        </.link>
        <.link href={~p"/recipes/new"}>
          <.button>New Recipe</.button>
          </.link>
      </:actions>
    </.header>

    <%= if length(@recipes) != 0 do %>
    <.table id="recipes" rows={@recipes} row_click={&JS.navigate(~p"/recipes/#{&1}")}>
      <:col :let={recipe} label="Title"><%= recipe.title %></:col>
      <:col :let={recipe} label="Status"><%= if recipe.is_draft do %> <.tag text="DRAFT"/> <% else %> <.tag text="LIVE" class="bg-green"/><% end %></:col>
      <:col :let={recipe} label="Description"><%= raw(recipe.description) %></:col>
      <:col :let={recipe} label="Tags"><.tags info={recipe.tags}/></:col>
      <:col :let={recipe} label="Cover"><img src={"#{recipe.cover}"} class="min-w-[100px] max-w-[180px]"></:col>
      <:action :let={recipe}>
        <div class="sr-only">
          <.link navigate={~p"/recipes/#{recipe}"}>Show</.link>
        </div>
        <.link navigate={~p"/recipes/#{recipe}/edit"} class="hover:text-brand">Edit</.link>
      </:action>
      <:action :let={recipe}>
        <.link href={~p"/recipes/#{recipe}"} method="delete" data-confirm="Are you sure?" class="hover:text-blood">
          Delete
        </.link>
      </:action>
    </.table>
    <% else%>
    <div class="mt-10 block text-sm font-semibold leading-6 text-zinc-500">No recipes yet 🤦‍♀️</div>
    <% end%>
    <.header class="mt-12">Change Username</.header>

    <.simple_form
      for={@username_form}
      id="username_form"
      phx-submit="update_username"
      phx-change="validate_username"
    >
      <.input field={{@username_form, :email}} type="hidden" value={@current_email} />
      <.input field={{@username_form, :username}} type="text" label="Username" required />
      <.input
        field={{@username_form, :current_password}}
        name="current_password"
        id="current_password_for_username"
        type="password"
        label="Current password"
        value={@username_form_current_password}
        required
      />
      <:actions>
        <.button phx-disable-with="Changing...">Change Username</.button>
      </:actions>
    </.simple_form>

    <.header class="mt-12">Change Email</.header>

    <.simple_form
      for={@email_form}
      id="email_form"
      phx-submit="update_email"
      phx-change="validate_email"
    >
      <.input field={{@email_form, :email}} type="email" label="Email" required />
      <.input
        field={{@email_form, :current_password}}
        name="current_password"
        id="current_password_for_email"
        type="password"
        label="Current password"
        value={@email_form_current_password}
        required
      />
      <:actions>
        <.button phx-disable-with="Changing...">Change Email</.button>
      </:actions>
    </.simple_form>

    <.header class="mt-12">Change Password</.header>

    <.simple_form
      for={@password_form}
      id="password_form"
      action={~p"/users/log_in?_action=password_updated"}
      method="post"
      phx-change="validate_password"
      phx-submit="update_password"
      phx-trigger-action={@trigger_submit}
    >
      <.input field={{@password_form, :email}} type="hidden" value={@current_email} />
      <.input field={{@password_form, :password}} type="password" label="New password" required />
      <.input
        field={{@password_form, :password_confirmation}}
        type="password"
        label="Confirm new password"
      />
      <.input
        field={{@password_form, :current_password}}
        name="current_password"
        type="password"
        label="Current password"
        id="current_password_for_password"
        value={@current_password}
        required
      />
      <:actions>
        <.button phx-disable-with="Changing...">Change Password</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    username_changeset = Accounts.change_username(user)
    password_changeset = Accounts.change_user_password(user)
    recipes = Recipes.list_recipes_by(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:current_username, user.username)
      |> assign(:username_form_current_password, nil)
      |> assign(:username_form, to_form(username_changeset))
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:recipes, recipes)

    {:ok, socket}
  end

  def handle_event("validate_username", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    username_form =
      socket.assigns.current_user
      |> Accounts.change_username(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, username_form: username_form, username_form_current_password: password)}
  end

  def handle_event("update_username", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_username(user, password, user_params) do
      {:ok, user} ->
        username_form =
          user
          |> Accounts.change_username(user_params)
          |> to_form()

        info = "Username updated 🎉"
        {:noreply, socket |> put_flash(:info, info) |> assign(username_form: username_form, username_form_current_password: nil, current_username: user.username)}

      {:error, changeset} ->
        {:noreply, assign(socket, :username_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
