defmodule HelloWorldTest do
  use ExUnit.Case
  doctest HelloWorld

  setup_all do
    assert {:ok, _server_pid} = HelloWorld.start_link(port: 4001)
    :ok
  end

  test "200 to GET /hello/world" do
    assert {:ok, resp} = HTTPoison.get("localhost:4001/hello/world")
    assert resp.status_code == 200
    assert resp.body == "Hello, World!"
  end

  test "404 to other requests" do
    assert {:ok, resp} = HTTPoison.get("localhost:4001/goodbye")
    assert resp.status_code == 404
    assert resp.body == "Our princess is in another castle..."
  end
end
