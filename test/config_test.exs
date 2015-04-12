defmodule ConfigTest do
    use ExUnit.Case

    test "version defaults to 2.2" do
        assert Facebex.Config.version == "2.2"
    end

    test "setting a config option" do
        Facebex.Config.set(:process, [foo: "bar"])
        assert Process.get(:security) == [foo: "bar"]

        assert "bar" === Facebex.Config.get(:process, :foo)
    end

    test "persist a token to disk works dext" do

        Facebex.Config.set_one(:process, :token, "12345678910")
        assert :ok == Facebex.Config.persist(:process, :token)

        Facebex.Config.load(:process)
        assert Facebex.Config.get(:process, :token) == "12345678910"
    end
end
