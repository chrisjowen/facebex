defmodule FacebexTest do
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use ExUnit.Case, async: false


  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

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
    use_cassette "group" do
      result =  Facebex.group(1540432296222124)
      assert "South Charlotte Buy/Sell Market" === result.name
      assert  %{"id" => "10153012381515129", "name" => "Ben Carter"} === result.owner
    end
  end

  test "test we can get a group feed" do 
    
    use_cassette "groupfeed" do 
      result = Facebex.group_feed(1540432296222124)
      assert length(result) === 6
      post = List.last(result)

      assert "Ben Carter created the group South Charlotte Buy/Sell Market." === post.story
      assert "status" === post.type
      assert "2015-02-27T04:36:00+0000" === post.updated_time
    end

  end

  test "test we can get group events" do
    result = Facebex.group_events(1540432296222124) 
    IO.inspect result
  end

end
