defmodule GithubAppWeb.CatchAllController do
  @moduledoc """
  This controller is useful to catch any request that was not defined
  into router.ex
  """

  use GithubAppWeb, :controller

  def index(conn, _params) do
    send_error(conn, 404, "Endpoint not found!")
  end
end
