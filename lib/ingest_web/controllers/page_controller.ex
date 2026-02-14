defmodule IngestWeb.PageController do
  use IngestWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
