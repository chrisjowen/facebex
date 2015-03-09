defmodule FacebookSDK.AccessToken do

    use Timex

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

       if ! is_binary(FacebookSDK.configure![:userAccessToken]) do
            raise "user access token is required to be setup to extend the token"
       end

       url = @authurl <> "?" <> buildParams
       result = HTTPoison.get(url)

       case parseResult(result) do
            {:ok, [token, expires]} -> FacebookSDK.configure([extendedToken: token,  tokenExpires: Time.now(:secs) + String.to_integer(expires)])
            {:error, reason} -> raise "facebook oauth extend error" <> reason
       end

    end

    def getToken do
               case FacebookSDK.configure![:extendedToken] do
                   nil ->
                       token = FacebookSDK.configure![:userAccessToken]
                   _ ->
                       token = FacebookSDK.configure![:extendedToken]
               end
             "?access_token=" <> token
           end

    defp buildParams do
        verify(FacebookSDK.configure!) ++ [{:grant_type,"fb_exchange_token"}]
        |> Enum.map(fn({k,v}) -> translate({k,v}) end) |> Enum.join("&")
    end

    defp translate({k,v}) do
        case k do
            :appId -> "client_id=#{v}"
            :appSecret -> "client_secret=#{v}"
            :userAccessToken -> "fb_exchange_token=#{v}"
            _ -> to_string(k) <> "=#{v}"
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