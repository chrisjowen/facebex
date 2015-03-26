defmodule Facebex do

    use Application
    use Timex

    def start(_type, _start) do    
        Facebex.Config.load
        Facebex.AccessToken.getPermToken
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

end
