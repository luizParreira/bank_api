defmodule BankApi.Web.DebtView do
  use BankApi.Web, :view

  def render("debt.json", %{debt: debt}) do
    %{data: debt}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
