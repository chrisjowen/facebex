defmodule FacebookSDK.Config do

    @default_path "/var/tmp/config.dict.bin"

    def get do
        :application.get_env(:facebook_sdk, :security)
    end
    def get(name) do
        {:ok, get![name]}
    end

    def get! do
        case get do
            {:ok, settings} -> settings
            nil -> {:error, "settings missing"}
            :undefined -> {}
        end

    end

    def configure(settings) do

        case get do 
            :undefined -> :application.set_env(:facebook_sdk, :security, settings)
            {:ok, list} -> :application.set_env(:facebook_sdk, :security, list ++ settings)
        end

    end
    def configure(setting, value) do
        configure([{setting, value}])
    end

    def version do
        case :application.get_env(:facebook_sdk, :graphApiVersion) do
            {:ok, version} -> version
            :undefined -> "2.2"
        end
    end

    def load do
      table = getDexts
      Dexts.keys(table) |> Enum.each(fn(key) -> 
        [{key,value}] = Dexts.read(table,key)
        configure(key,value)
        end)
    end

    def persist(name) do
       if(get![name]) do
            table = getDexts
            Dexts.write(table, {name, get![name]})
            Dexts.save table
       end
    end

    def getDexts do
        if is_binary(get![:storage_path]) do
            configPath = get![:storage_path]
        else 
            configPath = @default_path
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