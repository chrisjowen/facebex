defmodule FacebexTest do
  use ExUnit.Case
  setup do
        Application.delete_env(:facebex, :security)
  end

  test "test our application is started" do
    assert  {:error, {:already_started, :facebex}} == Application.start(:facebex)
  end

  test "test we can set security settings using the application" do
    assert Facebex.configure([
        appId: 12331,
        appSecret: "ab123b2d123411"
    ]) == :ok
  end

  test "test we can get security settigns using application" do
        Facebex.configure([
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])
        assert Facebex.configure == {:ok, [appId: 12331, appSecret: "ab123b2d123411"]}
  end

  test "we can add a access token to existing configuration" do
        Facebex.configure([
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])

        assert Facebex.configure(:accessToken, "123231-1232-232321-12332") == :ok
        assert Facebex.configure == {:ok, [appId: 12331, appSecret: "ab123b2d123411", accessToken: "123231-1232-232321-12332"]}
  end

  test "when setting a config setting that does not exist will lazy load keyword list" do
        assert Facebex.configure(:accessToken, "123231-1232-232321-12332") == :ok
        assert Facebex.configure == {:ok, [accessToken: "123231-1232-232321-12332"]}
  end

  test "access value directly from get" do
        Facebex.configure([
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])

        assert Facebex.configure![:appId] == 12331
        assert Facebex.configure![:accessToken] == nil
  end

end
