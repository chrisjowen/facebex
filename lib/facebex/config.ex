defmodule Facebex.Config do

  @default_path "/var/tmp/config.dict.bin"

 @doc """
  This will get the current scope of the settings either setup by the process or the global config started
  at application launch
 """
  def current_scope do
    if Process.get(:security, nil), do: :process, else: :global
  end

 @doc """
  Allow overrides at the process level if the user has chose to do so
  """
  def get, do: get(current_scope)
  def get(:global), do: Application.get_env(:facebex, :security)
  def get(:process), do: Process.get(:security)

 @doc """
  Get one settings from the security configuration
 """
  @spec get(<<>>) :: any
  def get(name), do: get(current_scope, name)
  def get(:global, name) do
    case get(:global) do 
      nil -> nil
      settings -> settings[name] 
    end
  end
  def get(:process, name) do
    case get(:process) do
      nil -> nil
      settings -> settings[name]
    end
  end

@doc """
Set security settings 
"""
  def set(settings), do: set(current_scope, settings)
  def set(:global, settings) do
    case get(:global) do 
      :undefined -> Application.set_env(:facebex, :security, settings)
      nil -> Application.put_env(:facebex, :security, settings)
      list -> Application.put_env(:facebex, :security, list ++ settings)
    end
  end
  def set(:process, settings) do
    case get(:process) do 
      :undefined -> Process.put(:security, settings)
      :nil -> Process.put(:security, settings)
      list -> Process.put(:security, list ++ settings) 
    end
  end

  def set_one(setting, value), do: set_one(current_scope, setting, value)
  def set_one(:global, setting, value), do: set(:global, [{setting, value}])
  def set_one(:process, setting, value), do: set(:process, [{setting, value}])

  def version do
    case :application.get_env(:facebex, :graphApiVersion) do
      {:ok, version} -> version
      :undefined -> "2.2"
    end
  end

  def load(scope \\ :global) do
    table = getDexts
    Dexts.keys(table) |> Enum.each(
      fn(key) -> 
        [{key,value}] = Dexts.read(table,key)
        set_one(scope, key, value)
      end
    )
  end

  def persist(scope \\ :global, name) do
   if(get(scope, name)) do
    table = getDexts
    Dexts.write(table, {name, get(scope,name)})
    Dexts.save table
  end
end

def getDexts(scope \\ :global) do
  configPath = cond do
    is_binary get(scope, :storage_path) -> get(scope, :storage_path)
    true -> @default_path
  end 

  if File.exists?(configPath)  do
    case Dexts.open(configPath) do
      {:ok, name} -> name
      {:error, reason} -> :logger.error(reason)
    end
  else
   case Dexts.new("perm_config", [path: configPath]) do
     {:ok, name} -> name
     {:error, reason} -> :logger.error(reason)
   end
 end
end

end