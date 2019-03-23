defmodule GithubAppWeb.Router do
  use GithubAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubAppWeb, as: :api do
    pipe_through :api

    get("/repositories/search/:tag", RepositoryController, :search)
    get("/repositories/:username/starred", RepositoryController, :index)
    post("/repositories/:id/tags", TagController, :create)
    put("/tags/:id", TagController, :update)
    delete("/tags/:id", TagController, :delete)
  end

  scope "/", GithubAppWeb do
    match(:*, "/*path", CatchAllController, :index)
  end
end
