require ("scenes/ui/ProgressBar")

ProgressMgr = {}
ProgressMgr.items = {}
ProgressMgr.item2widget = {}
ProgressMgr.widgetGroup = nil

function ProgressMgr:CreateWidgetGroupWithLayer(layer)
	self.widgetGroup = StackUIGroup:new(layer, 0, 200)
	self.widgetGroup:setAnchor(0, 0)
end

function ProgressMgr:CreateDefaultStyleBar()
	local widget = DefaultStyleBar:new()
	widget:setPercent(0)
	local function defaultUpdate(widget, widgetSize, percent)
		widget:setPercent(percent)
	end
	return widget, defaultUpdate
end

function ProgressMgr:CreateBarSpriteWithStyle(styleFunc)
	for _, func in pairs(self.Style) do
		if func==styleFunc then
			return func()
		end
	end
end

-- TODO: unfinied bar styles
ProgressMgr.Style = {
	["DefaultStyle"] = ProgressMgr.CreateDefaultStyleBar,
	["TextWithBarStyle"] = 2,
	["ImageWithBarStyle"] = 3,
	["TextAndImageWithBarStyle"] = 4,
	["CustomStyle"] = 5,
}


function ProgressMgr:AddItem(duration, barStyleInfo, notifyFunc, ...)
	local progressHandler = math.random()
	local progress = progressHandler
	self.items[progress] = {
		["notifyFunc"] = notifyFunc,
		["args"] = {...},
		["leftSeconds"] = duration,
		["totalSeconds"] = duration,
	}
	
	local progressWidget, updateFunc = self:CreateBarSpriteWithStyle(barStyleInfo)
	local size = progressWidget:getContentSize()
	self.item2widget[progress] = {
		["widget"] = progressWidget,
		["size"] = {
			["width"] = size.width,
			["height"] = size.height,
		},
		["update"] = updateFunc,
	}

	progressWidget:setPercent(0)
	self.widgetGroup:pushUIObj(progressWidget)
	return progressHandler
end

function ProgressMgr:ForEachItem(func, ...)
	for item,_ in pairs(self.items) do
		func(item, ...)
	end
end

function ProgressMgr:OnTick(delta)
	for item, itemInfo in pairs(self.items) do
		itemInfo.leftSeconds = itemInfo.leftSeconds-delta
		if itemInfo.notifyFunc then
			itemInfo.notifyFunc(item, itemInfo.leftSeconds, 
				unpack(itemInfo.args))
		end
		self.item2widget[item].update(
			self.item2widget[item].widget,
			self.item2widget[item].size,
			(1-itemInfo.leftSeconds/itemInfo.totalSeconds))
		if itemInfo.leftSeconds <= 0 then
			self:RemoveItem(item)
		end
	end
end


function ProgressMgr:RemoveItem(progressItem)
	local widget = self.item2widget[progressItem].widget
	self.widgetGroup:RemoveUIObj(widget)
	self.items[progressItem] = nil
end



