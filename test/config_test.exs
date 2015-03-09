defmodule ConfigTest do
    use ExUnit.Case

    setup do
        Application.delete_env(:facebook_sdk, :graphApiVersion)
    end

    test "version defaults to 2.2" do
        assert FacebookSDK.Config.version == "2.2"
    end

    test "version can be overriden" do
        Application.put_env(:facebook_sdk, :graphApiVersion, "2.0")
        assert FacebookSDK.Config.version == "2.0"
    end

end
