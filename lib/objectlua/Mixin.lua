local Object = require 'objectlua.Object'

local mixin = Object:subclass(...)

function mixin:subclass()
	local sub = super.subclass(self)
	local mt = getmetatable(sub)
	local newidx = mt.__newindex
	rawset(mt, '__newindex', function (t, k, v)
								assert('funciton' == type(v), "mixin only has functions.")
								return newidx(t, k, v)
							 end)
	return sub
end

function mixin.class:new(...)
	error("Error:Mixin can't be instanciated.")
end


return mixin
