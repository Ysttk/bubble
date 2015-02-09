
local MapName = "Scene548.png"
local MapSize = {Width = 800, Height=480}
local RoadInfo = {}
RoadInfo[1] = {{99, 480}, {577, 0}}
RoadInfo[2] = {{117, 480}, {595, 0}}
RoadInfo[3] = {{0, 30}, {800, 298}}
RoadInfo[4] = {{0,41}, {800, 309}}

local CrossInfo = {}
CrossInfo = {{416, 187}, {392, 178}, {410, 162}, {433, 170}}

local CarBornPos = {}
CarBornPos = {{139,455, 2}, {6, 46, 4}}

CScene548 = {}
function CScene548:GetMapName()
    return MapName
end

function CScene548:GetCarBornPos()
    return CarBornPos
end

function CScene548:GetMapSize()
    return MapSize.Width, MapSize.Height
end


function CScene548:GetRoadInfo()
    return RoadInfo
end


function CScene548:GetCrossInfo()
    return CrossInfo
end