defmodule Facebex do

    use Application
    use Timex

    def start(_type, _start) do    
        Facebex.Config.load
        getPermToken

        Facebex.Supervisor.start_link
    end

    def stop(app) do
        table = Facebex.Config.getDexts
        Dexts.close(table)
    end 

    @spec configure(Keyword.t) :: :ok
    defdelegate configure(settings), to: Facebex.Config, as: :configure

    @spec configure(Atom, <<>>) :: :ok
    defdelegate configure(setting, value), to: Facebex.Config, as: :configure

    @spec configure :: (Keyword.t) | nil
    defdelegate configure(), to: Facebex.Config, as: :get

    @spec configure :: (Keyword.t) | nil
    defdelegate configure!(), to: Facebex.Config, as: :get!

    defp getPermToken do
        case Facebex.configure![:extendedToken] do
            nil -> 
                spawn(Facebex.AccessToken, :extend, []) 
            x -> 
                cond do
                    is_number(Facebex.Config.get![:tokenExpires]) && Facebex.Config.get![:tokenExpires] < Time.now(:secs) -> 
                        spawn(Facebex.AccessToken, :extend, [])
                    true -> nil
                end

        end
    end

end
