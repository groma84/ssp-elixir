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
  end

  # Other scopes may use custom stacks.
  # scope "/api", SspWeb do
  #   pipe_through :api
  # end
end
