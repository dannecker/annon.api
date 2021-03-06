defmodule Annon.Acceptance.Smoke.PrivateRouterTest do
  @moduledoc false
  use Annon.AcceptanceCase, async: true

  setup do
    api = :api
    |> build_factory_params(%{
      name: "An HTTPBin service endpoint",
      request: %{
        methods: ["GET"],
        scheme: "http",
        host: get_endpoint_host(:private),
        port: get_endpoint_port(:private),
        path: "/httpbin",
      }
    })
    |> create_api()
    |> get_body()

    api_id = get_in(api, ["data", "id"])

    proxy_plugin = :proxy_plugin
    |> build_factory_params(%{settings: %{
      scheme: "http",
      host: "httpbin.org",
      port: 80,
      path: "/get",
      strip_api_path: true
    }})

    "apis/#{api_id}/plugins/proxy"
    |> put_management_url()
    |> put!(%{"plugin" => proxy_plugin})
    |> assert_status(201)

    :ok
  end

  test "A request from user reaches upstream" do
    response =
      "/httpbin?my_param=my_value"
      |> put_private_url()
      |> HTTPoison.get!([{"my-custom-header", "some-value"}, magic_header()])
      |> Map.get(:body)
      |> Poison.decode!

    assert "my_value" == response["args"]["my_param"]
    assert "some-value" == response["headers"]["My-Custom-Header"]
  end

  test "A request from public api does not reach upstream" do
    response =
      "/httpbin?my_param=my_value"
      |> put_public_url()
      |> HTTPoison.get!([{"my-custom-header", "some-value"}, magic_header()])
      |> Map.get(:body)
      |> Poison.decode!

    assert %{"error" => %{"type" => "not_found"}} = response
  end
end
