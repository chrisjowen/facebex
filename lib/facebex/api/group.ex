defmodule Facebex.API.Group do
    import Facebex.API.Base

    def group(id) do
    	url = endpoint(to_string(id))
        response = get(url)
        Poison.decode!(response.body, as: Facebex.Model.Group)
    end

    def feed(id) do
        url = endpoint(to_string(id),"/feed")
        response = get(url)
        Poison.decode!(response.body, keys: :atoms)[:data] 
         |> Enum.map(fn(post) -> struct(Facebex.Model.Post, post) end )
    end 

    def files(id) do
        url = endpoint(to_string(id),"/files")
        response = get(url)
        Poison.decode!(response.body, as: Facebex.Model.GroupFile)
    end

    def events(id) do 
        url = endpoint(to_string(id),"/events")
        response = get(url)
        Poison.decode!(response.body, keys: :atoms)[:data]
        |> Enum.map(fn(event) -> struct(Facebex.Model.Event, event) end ) 
    end

    def members(id) do
        url = endpoint(to_string(id),"/members")
        response = get(url)
        Poison.decode!(response.body, keys: :atoms)[:data]
         |> Enum.map(fn(member) -> struct(Facebex.Model.MemberShort, member) end )
    end

    def id_from_name(name) do
        url = endpoint("search","",[q: name, type: "group"])
        response = get(url)
        
        case Poison.decode!(response.body, keys: :atoms)[:data] do
            [] -> nil
            result -> struct(Facebex.Model.Group, hd(result)) 
        end

    end

end