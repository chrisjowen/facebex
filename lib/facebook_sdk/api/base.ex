defmodule FacebookSDK.API.Base do

	@facebook_url "https://graph.facebook.com/"

	alias FacebookSDK.AccessToken, as: Session
	alias FacebookSDK.Config, as: Config

    def endpoint(url) do
    	[@facebook_url,"v",Config.version,"/",url] |> Enum.join 
    end

end