defmodule Party1Web.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use Party1Web, :controller` and
  `use Party1Web, :live_view`.
  """
  use Party1Web, :html
  import Party1Web.Sidebar
  import Party1Web.Navbar
  import Party1Web.Footer

  embed_templates "layouts/*"
end
