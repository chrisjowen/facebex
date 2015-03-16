defmodule ConfigTest do
    use ExUnit.Case
    setup do
        Application.delete_env(:facebook_sdk, :graphApiVersion)
    end

    test "default config path is empty" do 
        assert Application.get_env(:facebook_sdk, :security) == "/tmp/config.dict.bin"
    end

    test "version defaults to 2.2" do
        assert FacebookSDK.Config.version == "2.2"
    end

    test "version can be overriden" do
        Application.put_env(:facebook_sdk, :graphApiVersion, "2.0")
        assert FacebookSDK.Config.version == "2.0"
    end

    test "persist a token to disk works dext" do
        Application.delete_env(:facebook_sdk, :security)

        FacebookSDK.Config.configure(:token, "12345678910")
        assert :ok == FacebookSDK.Config.persist(:token)

        Application.delete_env(:facebook_sdk, :security)

        FacebookSDK.Config.load
        assert FacebookSDK.Config.get(:token) == {:ok, "12345678910"}
    end

end
