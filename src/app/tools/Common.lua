
--deep copy function
function DeepCopy(obj)
	local target={}
	for k,v in pairs(obj) do
		if (type(v)=="table") then
			target[k] = DeepCopy(v)
		else
			target[k] = v
		end
	end
	return target
end


