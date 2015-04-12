defmodule FacebexTest do
  use ExUnit.Case

  test "test our application is started" do
    assert  {:error, {:already_started, :facebex}} == Application.start(:facebex)
  end

  test "test we can set and get security settings" do
        Facebex.configure(:process, [
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])
        assert Facebex.configure == [appId: 12331, appSecret: "ab123b2d123411"]
  end

  test "we can add a access token to existing configuration" do
        Facebex.configure(:process, [
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])

        Facebex.configure(:process, :accessToken, "123231-1232-232321-12332") 
        assert Facebex.configure == [appId: 12331, appSecret: "ab123b2d123411", accessToken: "123231-1232-232321-12332"]
  end

  test "when setting a config setting that does not exist will lazy load keyword list" do
        Facebex.configure(:process, :accessToken, "123231-1232-232321-12332") 
        assert Facebex.configure == [accessToken: "123231-1232-232321-12332"]
  end

  test "access value directly from get" do
        Facebex.configure(:process, [
            appId: 12331,
            appSecret: "ab123b2d123411"
        ])

        assert Facebex.configure(:process)[:appId] == 12331
        assert Facebex.configure(:process)[:accessToken] == nil
  end

  test "test we can get a known group" do
    result =  Facebex.group(1540432296222124)
    assert "South Charlotte Buy/Sell Market" === result.name
    assert  %{"id" => "10153012381515129", "name" => "Ben Carter"} === result.owner
  end

end
