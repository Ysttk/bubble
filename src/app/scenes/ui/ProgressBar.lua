StyleBarInterface = {}
function StyleBarInterface:addWidgetToLayer(layer)
end

function StyleBarInterface:getContentSize()
end

function StyleBarInterface:removeFromParent()
end

function StyleBarInterface:setPercent(percent)
end

function StyleBarInterface:getPosition()
end

function StyleBarInterface:adjustLblPosition()
end

function StyleBarInterface:setPosition(x, y)
end

function StyleBarInterface:setAnchorPoint(x, y)
end


-- @implement: StyleBarInterface
DefaultStyleBar = {}

function DefaultStyleBar:new()
	local newObj = DeepCopy(DefaultStyleBar)
	newObj.new = nil
	newObj.clone = DefaultStyleBar.new
	newObj.backgroupBar = cc.Sprite:create("progress.png")
	newObj.percentLbl = cc.LabelTTF:create("100", "Arial", 12)
	newObj.X, newObj.Y = 0,0
	local size = newObj.backgroupBar:getContentSize()
	newObj.TotalWidth = size.width
	return newObj
end

function DefaultStyleBar:addWidgetToLayer(layer)
	layer:addChild(self.backgroupBar)
	layer:addChild(self.percentLbl)
	StyleBarInterface.addWidgetToLayer(self, layer)
end

function DefaultStyleBar:getContentSize()
	return self.backgroupBar:getContentSize()
end

function DefaultStyleBar:removeFromParent()
	self.backgroupBar:removeFromParent()
	self.percentLbl:removeFromParent()
end

function DefaultStyleBar:setPercent(percent)
	local size = self.backgroupBar:getContentSize()
	self.backgroupBar:setTextureRect({
		x = 0, y = 0,
		width = math.floor(percent*self.TotalWidth),
		height = size.height,
	})
	local percentStr = string.format("%.1f%%", percent*100)
	self.percentLbl:setString(percentStr)
end

function DefaultStyleBar:getPosition()
	return self.backgroupBar:getPosition()
end

function DefaultStyleBar:adjustLblPosition()
	local x,y = self.backgroupBar:getPosition()
	local backAnchor = self.backgroupBar:getAnchorPoint()
	local backAnchorX, backAnchorY = backAnchor.x, backAnchor.y
	local size = self.backgroupBar:getContentSize()
	local width, height = self.TotalWidth, size.height
	local centerX, centerY = x+(0.5-backAnchorX)*width, y+(0.5-backAnchorY)*height
	self.percentLbl:setAnchorPoint(0.5, 0.5)
	self.percentLbl:setPosition(centerX,centerY)
end

function DefaultStyleBar:setPosition(x, y)
	self.X, self.Y = x,y
	self.backgroupBar:setPosition(x,y)
	self:adjustLblPosition()
end

function DefaultStyleBar:setAnchorPoint(x, y)
	self.AnchorX, self.AnchorY = x,y
	self.backgroupBar:setAnchorPoint(x, y)
	self:adjustLblPosition()
end


