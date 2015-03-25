defmodule FacebookSDK.API.Group do

    alias FacebookSDK.AccessToken, as: Session
    import FacebookSDK.API.Base

    def group(id) do
    	url = endpoint(to_string(id)) <> Session.getTokenString
        makeRequest(url)
    end

    def groupfeed(id) do
        url = endpoint(to_string(id) <> "/feed") <> Session.getTokenString
        response = HTTPoison.get! url
        Poison.decode!(response.body, keys: :atoms)[:data] 
        	|> Enum.map(fn(post) -> {struct(FacebookSDK.Model.Post, post)} end )
    end 

end