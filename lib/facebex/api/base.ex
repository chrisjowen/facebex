defmodule Facebex.API.Base do

	@facebook_url "https://graph.facebook.com/"

	alias Facebex.AccessToken, as: Session
	alias Facebex.Config, as: Config

    def endpoint(url, suffix \\ "", params \\ []) do
      if length params do
        query_params =  params 
         |> Enum.map(fn({k,v}) -> "&#{k}=#{v}" end)
      else 
        query_params = ""
      end
    	[@facebook_url,"v",Config.version,"/",url,suffix,Session.getTokenString,query_params]  
       |> Enum.join 
    end

    def get(url) do      
    	case HTTPoison.get(url, keys: :atoms) do
        {:ok, response} -> 
    			process(response)

    		{:error, response} ->
          raise %Facebex.Error{ 
    				message: "error fetching a response: " <> to_string(response.reason)
    			}
    	end 
   	end

   	def process(response) do
   		body = Poison.Parser.parse!(response.body, keys: :atoms)
 
   		case Map.get(body, :error, nil) do
   			nil ->
   				response
 
   			error ->
   				raise %Facebex.Error{
   					message: error.type <> ": " <> error.message,
   					code: error.code,
   					type: error.type
   				}
   		end 
   	end

end