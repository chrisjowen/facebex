defmodule Facebex do
    use Application
    use Timex

    def start(_type, _start) do    
        Facebex.Config.load
        Facebex.AccessToken.getPermToken
        Facebex.Supervisor.start_link
    end

    def stop(_app) do
        table = Facebex.Config.getDexts
        Dexts.close(table)
    end 

    @spec configure(:global | :process, Keyword.t) :: :ok
    defdelegate configure(scope, settings), to: Facebex.Config, as: :set

    @spec configure(:global | :process, Atom, <<>>) :: :ok
    defdelegate configure(scope, setting, value), to: Facebex.Config, as: :set_one

    @spec configure :: (Keyword.t) | nil
    defdelegate configure, to: Facebex.Config, as: :get

    @spec configure(:global | :process) :: (Keyword.t) | nil
    defdelegate configure(scope), to: Facebex.Config, as: :get

    @spec group(integer) :: Facebex.Model.Group
    defdelegate group(id), to: Facebex.API.Group, as: :group

    @spec group_feed(integer) :: [Facebex.Model.Post]
    defdelegate group_feed(id), to: Facebex.API.Group, as: :feed

    @spec group_files(integer) :: [Facebex.Model.GroupFile]
    defdelegate group_files(id), to: Facebex.API.Group, as: :files

    @spec group_events(integer) :: [Facebex.Model.Events]
    defdelegate group_events(id), to: Facebex.API.Group, as: :events

    @spec group_members(integer) :: [Facebex.Model.Membershort]
    defdelegate group_members(id), to: Facebex.API.Group, as: :members

    @spec group_id_from_name(<<>>) :: Facebex.Model.Group
    defdelegate group_id_from_name(name), to: Facebex.API.Group, as: :id_from_name

end
