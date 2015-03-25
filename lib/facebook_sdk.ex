defmodule FacebookSDK do

    use Application
    use Timex

    def start(_type, _start) do    
        FacebookSDK.Config.load
        getPermToken

        FacebookSDK.Supervisor.start_link
    end

    def stop(app) do
        table = FacebookSDK.Config.getDexts
        Dexts.close(table)
    end 

    @spec configure(Keyword.t) :: :ok
    defdelegate configure(settings), to: FacebookSDK.Config, as: :configure

    @spec configure(Atom, <<>>) :: :ok
    defdelegate configure(setting, value), to: FacebookSDK.Config, as: :configure

    @spec configure :: (Keyword.t) | nil
    defdelegate configure(), to: FacebookSDK.Config, as: :get

    @spec configure :: (Keyword.t) | nil
    defdelegate configure!(), to: FacebookSDK.Config, as: :get!

    defp getPermToken do
        case FacebookSDK.configure![:extendedToken] do
            nil -> 
                spawn(FacebookSDK.AccessToken, :extend, []) 
            x -> 
                cond do
                    is_number(FacebookSDK.Config.get![:tokenExpires]) && FacebookSDK.Config.get![:tokenExpires] < Time.now(:secs) -> 
                        spawn(FacebookSDK.AccessToken, :extend, [])
                    true -> nil
                end

        end
    end

end
