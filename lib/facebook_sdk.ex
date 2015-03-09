defmodule FacebookSDK do

    use Application

    def start(_type, _start) do
        FacebookSDK.Supervisor.start_link
    end

    @spec configure(Keyword.t) :: :ok
    defdelegate configure(settings), to: FacebookSDK.Config, as: :configure

    @spec configure(Atom, <<>>) :: :ok
    defdelegate configure(setting, value), to: FacebookSDK.Config, as: :configure

    @spec configure :: (Keyword.t) | nil
    defdelegate configure(), to: FacebookSDK.Config, as: :get

    @spec configure :: (Keyword.t) | nil
    defdelegate configure!(), to: FacebookSDK.Config, as: :get!

end
