defmodule Facebex.Parser do

	alias Facebex.Model.Error

    @spec parseError(HTTPoison.Response) :: Facebex.Model.Error
	def parseError(response) do
		Poison.decode!(response.body, as: Error)
	end

end
