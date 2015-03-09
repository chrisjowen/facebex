defmodule FacebookSDK.API.Group do

    alias FacebookSDK.AccessToken, as: Session

    def group(id) do
        url = "https://graph.facebook.com/v2.2/" <> to_string(id) <> "/feed" <> Session.getToken
        IO.inspect url
        response = HTTPoison.get! url
        response
    end

end