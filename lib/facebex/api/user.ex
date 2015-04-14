defmodule Facebex.API.User do
  import Facebex.API.Base

  def search_by_name(name) do
	url = endpoint("search","",[q: name, type: "user"])
	response = get(url)

	Poison.decode!(response.body, keys: :atoms)[:data] 
	  |> Enum.map(fn(member) -> struct(Facebex.Model.MemberShort, member) end) 
  end
  def search_by_name(name, :full_user) do
  	main = self 

  	user_list = search_by_name(name)	
  	new_list = []
  
  	if length(user_list) do

  		Enum.each(user_list, fn(user) -> 
  			spawn(Facebex.API.User, :get_user_ack, [main, user.id])
  		end)

		receive do
  			{:user_found, user} -> [new_list | user]
  		end
  	end 

  end

  def get_by_username(username) do
  	url = endpoint(username)
  	response = get(url)

  	IO.inspect response 
  end

  def get_user(id) do
  	url = endpoint(to_string(id))
    response = get(url)
    Poison.decode!(response.body, as: Facebex.Model.User)
  end

  def get_user_ack(pid, id) do
    user = get_user(id)
  	IO.inspect user
  	#send(pid, {:user_found, user})  
  end

end