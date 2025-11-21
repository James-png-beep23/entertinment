defmodule Party1Web.Sidebar do
 use Party1Web, :html
  # import Party1Web.CoreComponents
  # import Party1Web, only: [verified_routes: 0]

  def sidebar(assigns) do
    ~H"""
    <aside class="w-64 bg-gray-800 text-white p-4 min-h-screen">
      <ul class="space-y-4">
        <li><a href="/dashboard">Dashboard</a></li>
        <li><a href="/users">Users</a></li>
        <li><a href="/settings">Settings</a></li>
        <li><a href={~p"/events/new"}>Create Events</a></li>
      </ul>
    </aside>
    """
  end
end
