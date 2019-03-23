defmodule GithubApp.Repositories.RecommendationsCache do
  @moduledoc """
  Use this module to cache recommendations and avoid to load tags from database many times.
  """
  use Agent

  alias GithubApp.Repositories
  alias GithubApp.Repositories.Repository

  def start_link(initial_state \\ []) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def build_recommendations(%Repository{} = repo) do
    %Repository{ repo | tag_recommendations: [repo.name | load()] }
  end

  defp load do
    recommendations = Agent.get(__MODULE__, & &1)

    if Enum.empty?(recommendations) do
      sample()
      |> Enum.concat(Repositories.list_tags())
      |> Enum.shuffle()
      |> Enum.chunk_every(5)
      |> update_cache()
    end

    Agent.get_and_update(__MODULE__, fn [head | tail] ->
      {head, tail}
    end)
  end

  defp update_cache(recommendations) do
    Agent.update(__MODULE__, fn _state -> recommendations end)
  end

  defp sample do
    [
      "backend",
      "back-end",
      "frontend",
      "front-end",
      "boostrap",
      "php",
      "javascript",
      "angular",
      "lua",
      "react",
      "react-native",
      "elixir",
      "python",
      "machine-learning",
      "java",
      "tensorflow",
      "seo",
      "marketing",
      "vue",
      "elm",
      "node",
      "nodejs",
      "ruby",
      "server",
      "heroku",
      "digital",
      "materialize",
      "skeleton",
      "foundation",
      "milligram",
      "rust",
      "go",
      "swift",
      "kotlin",
      "typescript"
    ]
  end
end
