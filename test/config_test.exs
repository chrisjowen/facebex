defmodule ConfigTest do
    use ExUnit.Case
    setup do
        Application.delete_env(:facebex, :graphApiVersion)
    end

    test "default config path is empty" do 
        assert Application.get_env(:facebex, :security) == "/tmp/config.dict.bin"
    end

    test "version defaults to 2.2" do
        assert Facebex.Config.version == "2.2"
    end

    test "version can be overriden" do
        Application.put_env(:facebex, :graphApiVersion, "2.0")
        assert Facebex.Config.version == "2.0"
    end

    test "persist a token to disk works dext" do
        Application.delete_env(:facebex, :security)

        Facebex.Config.configure(:token, "12345678910")
        assert :ok == Facebex.Config.persist(:token)

        Application.delete_env(:facebex, :security)

        Facebex.Config.load
        assert Facebex.Config.get(:token) == {:ok, "12345678910"}
    end

end
