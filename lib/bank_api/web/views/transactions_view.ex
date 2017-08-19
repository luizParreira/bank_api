defmodule BankApi.Web.TransactionsView do
  use BankApi.Web, :view

  def render("success.json", %{transaction: _transaction}) do
    %{data: "success"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
