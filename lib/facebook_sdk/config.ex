defmodule FacebookSDK.Config do

    def get do
        :application.get_env(:facebook_sdk, :security)
    end

    def get! do
        case get do
            {:ok, settings} -> settings
            nil -> {:error, "settings missing"}
        end

    end

    def configure(settings) do
        :application.set_env(:facebook_sdk, :security, settings)
    end

    def configure(setting, value) do

        case get do
            :undefined -> configure([{setting, value}])
            {:ok, list} -> configure(list ++ [{setting, value}])
        end

    end

    def version do
        case :application.get_env(:facebook_sdk, :graphApiVersion) do
            {:ok, version} -> version
            :undefined -> "2.2"
        end
    end
end