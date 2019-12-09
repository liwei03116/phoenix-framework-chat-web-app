defmodule ChitChatEnWeb.Router do
  use ChitChatEnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChitChatEn.Auth
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChitChatEnWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    resources("/rooms", RoomController)
    resources("/users", UserController)
    resources("/sessions", SessionController, only: [:new, :create, :delete], singleton: true)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChitChatEnWeb do
  #   pipe_through :api
  # end
  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      user_id_token = Phoenix.Token.sign(conn, "user_id", current_user.id)
      assign(conn, :user_id, user_id_token)
    else
      conn
    end
  end
end
