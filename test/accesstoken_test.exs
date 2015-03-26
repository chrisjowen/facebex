defmodule AccessTokenTest do
    use ExUnit.Case

    alias Facebex.AccessToken, as: AccessToken

    test "verify will throw an error if accesstoken,appId,appSecret are empty" do
        assert catch_error(AccessToken.verify([])) == %RuntimeError{message: "api calls require at minimum appId and appSecret"}
    end

    test "if our values are set we will not throw an error" do
        assert AccessToken.verify([userAccessToken: "123", appId: "12332", appSecret: "12323"]) == [userAccessToken: "123", appId: "12332", appSecret: "12323"]
    end

end