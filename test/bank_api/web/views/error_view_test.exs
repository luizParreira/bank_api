defmodule BankApi.Web.ErrorViewTest do
  use BankApi.Web.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(BankApi.Web.ErrorView, "404.json", []) ==
           %{error: %{type: "NotFound", message: "Account does not exist"}}
  end

  test "renders 400.json" do
    assert render(BankApi.Web.ErrorView, "400.json", []) ==
           %{error: %{type: "BadRequest", message: "bad request"}}
  end

  test "render 500.json" do
    assert render(BankApi.Web.ErrorView, "500.json", []) ==
            %{error: %{detail: "Internal server error"}}
  end

  test "render any other" do
    assert render(BankApi.Web.ErrorView, "505.json", []) ==
           %{error: %{detail: "Internal server error"}}
  end
end
