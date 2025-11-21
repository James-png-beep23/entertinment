defmodule Party1Web.PageController do
  use Party1Web, :controller

  alias Party1.Context
  # alias Party1.Context.Event

  def home(conn, _params) do
    events = Context.list_events()
    render(conn, :home, events: events)
  end

end
