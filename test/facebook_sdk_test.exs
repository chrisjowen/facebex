defmodule FacebookSdkTest do
  use ExUnit.Case
  setup do
        Application.delete_env(:facebook_sdk, :security)
  end

  test "test our application is started" do
    assert  {:error, {:already_started, :facebook_sdk}} == Application.start(:facebook_sdk)
  end

  test "test we can set security settings using the application" do
    assert FacebookSDK.configure([
        appId: 12331,
        appSecret: "ab123b2d123411"
    ]) == :ok
  end

  test "test we can get security settigns using application" do
        FacebookSDK.configure([
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])
        assert FacebookSDK.configure == {:ok, [appId: 12331, appSecret: "ab123b2d123411"]}
  end

  test "we can add a access token to existing configuration" do
        FacebookSDK.configure([
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])

        assert FacebookSDK.configure(:accessToken, "123231-1232-232321-12332") == :ok
        assert FacebookSDK.configure == {:ok, [appId: 12331, appSecret: "ab123b2d123411", accessToken: "123231-1232-232321-12332"]}
  end

  test "when setting a config setting that does not exist will lazy load keyword list" do
        assert FacebookSDK.configure(:accessToken, "123231-1232-232321-12332") == :ok
        assert FacebookSDK.configure == {:ok, [accessToken: "123231-1232-232321-12332"]}
  end

  test "access value directly from get" do
        FacebookSDK.configure([
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])

        assert FacebookSDK.configure![:appId] == 12331
        assert FacebookSDK.configure![:accessToken] == nil
  end

end
