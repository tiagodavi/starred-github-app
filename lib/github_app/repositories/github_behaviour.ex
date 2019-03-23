defmodule GithubApp.Repositories.GithubBehaviour do
  @moduledoc """
  Use this behavior to ensure github modules implement correct functions.
  """
  alias GithubApp.Repositories.Repository

  @callback list_starred(String.t()) :: list(%Repository{})
end
