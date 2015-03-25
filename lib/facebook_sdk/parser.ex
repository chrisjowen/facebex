defmodule FacebookSDK.Parser do

	alias FacebookSDK.Model.Error

    @spec parseError(HTTPoison.Response) :: FacebookSDK.Model.Error
	def parseError(response) do
		Poison.decode!(response.body, as: Error)
	end

end
