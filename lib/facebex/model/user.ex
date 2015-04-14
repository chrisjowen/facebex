defmodule Facebex.Model.User do 
	@doc """
	Facebook User data model
	This is referenced on [https://developers.facebook.com/docs/graph-api/reference/user]
	"""
	defstruct id: nil,
	about: nil,
	address: nil,
	age_range: nil,
	bio: nil,
	birthday: nil,
	context: nil,
	devices: [],
	education: [],
	first_name: nil,
	gender: nil,
	email: nil,	
	last_name: nil,
	link: nil,
	middle_name: nil,
	name: nil,
	cover: nil

end