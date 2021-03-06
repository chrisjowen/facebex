defmodule Facebex.AccessToken do

    use Timex
    alias Facebex.Config, as: Config

    @authurl "https://graph.facebook.com/oauth/access_token"

    def verify([]) do
        raise "api calls require at minimum appId and appSecret"
    end
    def verify(params) do
       if  ! ( is_binary(params[:appId]) && is_binary(params[:appSecret]) ) do
            raise "appId and appSecret settings need to be set as binary strings"
       end
       params
    end

    def extend do

       if ! is_binary(Config.get(:userAccessToken))  && ! is_binary(Config.get(:extendedToken)) do
            raise "user access token / extended toen  is required to be setup to extend the token"
       end

       url = @authurl <> "?" <> buildParams
       result = HTTPoison.get(url)

       case parseResult(result) do
            {:ok, [token, expires]} ->
                Config.set([extendedToken: token,  tokenExpires: Time.now(:secs) + String.to_integer(expires)])
                Config.persist(:extendedToken); 
                Config.persist(:tokenExpires); 
            {:error, reason} -> raise "facebook oauth extend error" <> reason
       end

    end

    def getTokenString do
      case Config.get(:extendedToken) do
        nil ->
          token = Config.get(:userAccessToken)
        _ ->
          token = Config.get(:extendedToken)
        end
      "?access_token=" <> token
    end

    def getPermToken do
      case Config.get(:extendedToken) do
        nil -> 
          spawn(Facebex.AccessToken, :extend, []) 
        _ -> 
          cond do
            is_number(Config.get(:tokenExpires)) && Config.get(:tokenExpires) < Time.now(:secs) -> 
              spawn(Facebex.AccessToken, :extend, [])
            true -> nil
          end
      end
    end

    defp buildParams do
        verify(Config.get) ++ [{:grant_type,"fb_exchange_token"}]
          |> Enum.map(fn({k,v}) -> 
                translate({k,v}) 
             end) 
          |> Enum.filter(fn(x) -> 
                case x do 
                  nil -> false
                  _ -> true
                end
             end)
          |> Enum.join("&")
    end

    defp translate({k,v}) do
        case k do
            :appId -> "client_id=#{v}"
            :appSecret -> "client_secret=#{v}"
            :grant_type -> "grant_type=fb_exchange_token"
            :extendedToken -> "fb_exchange_token=#{v}"
            :userAccessToken -> if Config.get(:extendedToken), do: "fb_exchange_token=#{v}"
            _ -> nil
        end
    end

    defp parseResult(result) do
        case result do
            {:ok, %HTTPoison.Response{status_code: 200,  body: body}} ->

                result = String.split(body, "&") |> Enum.map(fn(x) ->
                    [_,value] = String.split(x,"=")
                    value
                end )

                {:ok, result}

            {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
        end
    end

end