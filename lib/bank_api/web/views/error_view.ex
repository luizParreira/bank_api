defmodule BankApi.Web.ErrorView do
  use BankApi.Web, :view

  def render("404.json", _assigns) do
    %{error: %{type: "NotFound", message: "Account does not exist"}}
  end

  def render("400.json", _assigns) do
    %{error: %{type: "BadRequest", message: "bad request"}}
  end

  def render("500.json", _assigns) do
    %{error: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
