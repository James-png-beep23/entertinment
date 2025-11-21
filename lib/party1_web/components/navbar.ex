defmodule Party1Web.Navbar do
  use Party1Web, :html

  def navbar(assigns) do
    ~H"""
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gradient-to-r from-blue-500 to-indigo-600 flex items-center justify-center text-white font-bold text-lg">EB</div>
            <span class="ml-3 text-xl font-bold text-gray-900">EventHub</span>
          </div>

          <%= if @current_user do %>
            <!-- Logged in user navigation -->
            <div class="hidden md:flex space-x-8">
              <.link href={~p"/"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Home
              </.link>
              <.link href={~p"/party"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Events
              </.link>
              <.link href={~p"/party"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                About
              </.link>
              <.link href={~p"/users/settings"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Settings
              </.link>
            </div>

            <div class="flex gap-2">
              <.link href={~p"/users/log_out"} method="delete" class="px-2 py-1 rounded-lg bg-red-500 text-white hover:bg-red-600">
                Log out
              </.link>
            </div>
          <% else %>
            <!-- Guest user navigation -->
            <div class="hidden md:flex space-x-8">
              <.link href={~p"/"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Home
              </.link>
              <.link href={~p"/party"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Events
              </.link>
              <.link href={~p"/"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Cart
              </.link>
              <.link href={~p"/"} class="px-2 py-1 rounded-lg bg-zinc-100 hover:bg-zinc-200/80">
                Contact Us
              </.link>
            </div>

            <div class="flex gap-2">
              <.link href={~p"/users/log_in"} class="px-2 py-1 rounded-lg bg-blue-500 text-white hover:bg-blue-600">
                Sign in →
              </.link>
            </div>
          <% end %>
        </div>
      </div>
    </nav>
    """
  end
end
