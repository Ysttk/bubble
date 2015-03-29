

MostBrightnessDecP = 0.05
LeastBrightnessDecP = 0.8
RandomBrightnessRange = 0.2

WorldModel = {}
WorldModel.MaxPeopleNum = 0
WorldModel.PeopleNum = 0
WorldModel.FogThickness = 0
WorldModel.FogIncDegree = 0
WorldModel.Brightness = 1



function WorldModel:Init(peopleNum, fogThickness, fogIncDegree, brightness)
	self.PeopleNum = peopleNum
	self.FogThickness = fogThickness
	self.FogIncDegree = fogIncDegree
	self.Brightness = brightness
	self.MaxPeopleNum = peopleNum
end


function WorldModel:OnTick(deltaTime)
	local p = self.PeopleNum / self.MaxPeopleNum
	local brightUpMostPercent = (p*p)*(LeastBrightnessDecP-MostBrightnessDecP)+LeastBrightnessDecP
	local brightDecPercent = math.sqrt(1-self.Brightness)*(1-RandomBrightnessRange*math.random())*brightUpMostPercent
	self.PeopleNum = self.PeopleNum * (math.sqrt(math.sqrt(1 - self.FogThickness))) - brightDecPercent*self.PeopleNum
	self.FogThickness = self.FogThickness + self.FogIncDegree
	if self.FogThickness>1 then self.FogThickness=1 end
	self.Brightness = self.FogThickness/2
end



