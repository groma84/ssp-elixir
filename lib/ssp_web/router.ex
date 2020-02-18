defmodule SspWeb.Router do
  use SspWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SspWeb do
    pipe_through :browser

    get "/", LobbyController, :index

    get "/game/new/:player_id/:player_name", GameController, :new
    get "/game/join/:player_id/:player_name/:game_id", GameController, :join
    get "/game/play/:player_id/:game_id", GameController, :play
  end

  # Other scopes may use custom stacks.
  # scope "/api", SspWeb do
  #   pipe_through :api
  # end
end
