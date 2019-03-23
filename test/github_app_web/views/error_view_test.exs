defmodule GithubAppWeb.ErrorViewTest do
  use GithubAppWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(GithubAppWeb.ErrorView, "404.json", []) == %{error: "Endpoint not found!"}
  end

  test "renders 500.json" do
    assert render(GithubAppWeb.ErrorView, "500.json", []) == %{error: "Internal Server Error!"}
  end
end
