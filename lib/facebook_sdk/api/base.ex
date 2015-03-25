defmodule FacebookSDK.API.Base do

	@facebook_url "https://graph.facebook.com/"

	alias FacebookSDK.AccessToken, as: Session
	alias FacebookSDK.Config, as: Config

    def endpoint(url) do
    	[@facebook_url,"v",Config.version,"/",url] |> Enum.join 
    end

    def makeRequest(url) do
    	case HTTPoison.get(url, keys: :atoms) do
    		{:ok, response} -> 
    			process(response)
    		{:error, response} ->
    			raise %FacebookSDK.Error{ 
    				message: "error fetching a response: " <> to_string(response.reason)
    			}
    	end 
   	end

   	def process(response) do
   		body = Poison.Parser.parse!(response.body, keys: :atoms)
   		IO.inspect Map.get(body, :error)
   		case Map.get(body, :error, nil) do
   			nil ->
   				response
   			error ->
   				raise %FacebookSDK.Error{
   					message: error.type <> ": " <> error.message,
   					code: error.code,
   					type: error.type
   				}
   		end 
   	end

end