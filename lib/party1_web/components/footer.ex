defmodule Party1Web.Footer do
  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <footer class="bg-gray-900 text-gray-300 p-4 text-center">
      © <%= Date.utc_today().year %> MyApp. All rights reserved.
    </footer>
    """
  end
end
