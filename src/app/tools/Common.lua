
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

function DeepDumpInner(obj, currentDeep, maxDeep)
	if currentDeep > maxDeep then
		return 
	end
	local prefix = ""
	for i = 1,currentDeep do
		prefix = prefix.."\t"
	end

	for k,v in pairs(obj) do
		print(prefix..k,v)
		if type(v)=="table" then
			DeepDumpInner(obj, currentDeep, maxDeep)
		end
	end
end

function DeepDump(obj, maxDeep)
	print("Begin Dump of :", obj)
	DeepDumpInner(obj, 0, maxDeep)
	print("End Dump")
end

