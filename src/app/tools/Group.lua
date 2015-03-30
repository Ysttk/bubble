
require ("Common")

--gui group definition
--用于管理一堆的当做ui widget用的sprite
UIGroup = {}
UIGroupMgr = {}

-- class static variable
UIGroupMgr.widget2GroupObj = {}
UIGroupMgr.groups = {}

-- class static function
function UIGroupMgr:FindGroupByWidget(widget)
	return UIGroupMgr.widget2GroupObj[widget]
end

function UIGroupMgr:foreachGroup(funcHandler)
	for group, layer in pairs(self.groups) do
		funcHandler(group)
	end
end


-- object function

function UIGroup:new(layer)
	local newObj = DeepCopy(UIGroup)
	newObj.new = nil
	newObj.clone = UIGroup.new
	newObj.widgets = {}
	newObj.widgetOrigPos = {}
	newObj.widgetTouchAction = {}
	newObj.rect = {}
	newObj.rect.start = {0,0}
	newObj.rect.size = {0,0}
	newObj.AnchorX, newObj.AnchorY = 0.5, 0.5
	UIGroupMgr.groups[newObj] = layer
	return newObj
end

function UIGroup:addUIObj(obj)
	if self.X and self.Y then
		local objX, objY = obj:getPosition()
		local anchorX, anchorY = self.AnchorX, self.AnchorY
		local size = obj:getContentSize()
		obj:setAnchorPoint(anchorX, anchorY)
		obj:setPosition(self.X+objX+size.width*anchorX, self.Y+objY+size.height*anchorY)
		self.widgetOrigPos[obj]={objX, objY}
		if not self.rect.size then
			self.rect.size = {0, 0}
		end
	
		self.rect.size[1] = math.max(self.rect.size[1], objX+size.width)
		self.rect.size[2] = math.max(self.rect.size[2], objY+size.height)
	end
	table.insert(self.widgets, obj)
	local layer = UIGroupMgr.groups[self]
	layer:addChild(obj)
end

function UIGroup:setPos(x,y)
	self.X = x
	self.Y = y
	self.rect.start = {x,y}
	if not self.rect.size then
		self.rect.size = {0, 0}
	end
	local anchorX, anchorY = self.AnchorX, self.AnchorY
	for _, widget in pairs(self.widgets) do
		local origX, origY = unpack(self.widgetOrigPos[widget])
		local size = widget:getContentSize()
		obj:setAnchorPoint(anchorX, anchorY)
		widget:setPosition(x+origX+size.widget*anchorX, y+origY+size.height*anchorY)
		self.rect.size[1] = math.max(self.rect.size[1], origX+size.widget)
		self.rect.size[2] = math.max(self.rect.size[2], origY+size.height)
	end
end

function UIGroup:setAnchor(x, y)
	self.AnchorX = x
	self.AnchorY = y
	for _, widget in pairs(self.widgets) do
		local origX, origY = unpack(self.widgetOrigPos[widget])
		local size = widget:getContentSize()
		obj:setAnchorPoint(x, y)
		widget:setPosition(self.X+size.width*x, self.Y+size.height*y)
	end
end

function UIGroup:isInRect(x, y)
	if (x>=self.rect.start[1] and x<(self.rect.start[1]+self.rect.size[1]) and
		y>=self.rect.start[2] and x<(self.rect.start[2]+self.rect.size[2])) then
		return true
	else
		return false
	end
end

function UIGroup:setTouchHandler(widget, funcHandler, ...)
	local actionInfo = {}
	actionInfo.FuncHandler = funcHandler
	actionInfo.Args = {...}
	self.widgetTouchAction[widget] = actionInfo
end

function UIGroup:onTouchEvent(eventType, x, y)
	for _, widget in pairs(self.widgets) do
		local startX, startY = widget:getPosition()
		local size = widget:getContentSize()
		local sizeW, sizeH = size.width, size.height
		if (x>=startX and x<(startX+sizeW) and
			y>=startY and y<(startY+sizeH)) then
			local actionInfo = self.widgetTouchAction[widget]
			if actionInfo then
				actionInfo.FuncHandler(widget, unpack(actionInfo.Args))
				return
			end
		end
	end
end


function UIGroup:clearAll()
	for _, widget in pairs(self.widgets) do
		widget:removeFromParent()
	end
	self.widgets = {}
	self.widgetOrigPos = {}
	self.rect.size = {0,0}
end

-- StackUIGroup 支持自动坐标排列，用户只需要调用pushUIObj
-- StackUIGroup自动将widget插入显示在最下面
StackUIGroup = {}
StackUIGroup.clearAll = UIGroup.clearAll

function StackUIGroup:new(layer, x, y)
	local obj = UIGroup.new(self, layer)
	for k,v in pairs(self) do
		if (k~="new" and type(v)=="function") then
			obj[k]=v
		end
	end
	obj.X, obj.Y = x, y
	return obj
end

function StackUIGroup:pushUIObj(obj)
	local size = obj:getContentSize()
	local w,h = size.width, size.height
	local anchorX, anchorY = self.AnchorX, self.AnchorY
	obj:setAnchorPoint(self.AnchorX, self.AnchorY)
	obj:setPosition(anchorX*w, anchorY*h)
	--obj:setPosition(w, h)
	for obj, posInfo in pairs(self.widgetOrigPos) do
		posInfo[2] = posInfo[2]+h
		local objX, objY = obj:getPosition()
		obj:setPosition(objX, objY+h)
	end

	UIGroup.addUIObj(self, obj)
end

function StackUIGroup:RemoveUIObj(widget)
	local size = widget:getContentSize()
	local w,h = size.width, size.height
	local wX, wY = widget:getPosition()
	widget:removeFromParent()
	self.widgetOrigPos[widget] = nil
	local idx = nil
	for i, obj in pairs(self.widgets) do
		idx = i
		break
	end
	table.remove(self.widgets, idx)
	
	for obj, posInfo in pairs(self.widgetOrigPos) do
		local objX, objY = obj:getPosition()
		if objY>wY then
			objY = objY - h
			obj:setPosition(objX, objY)
			posInfo[2] = posInfo[2] - h
		end
	end
end

function StackUIGroup:setPos(x, y)
	UIGroup.setPos(self, x, y)
end

