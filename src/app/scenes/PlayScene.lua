
local PlayScene = class("PlayScene", function()
    return display.newPhysicsScene("PlayScene")
end)

function PlayScene:ctor(sceneName)
    require (sceneName)
    self.m_SceneName = sceneName
    self.m_MapInfo = _G["C"..sceneName]
    printInfo(self.m_MapInfo:GetMapName())
    
    local mapInfo = self.m_MapInfo
    local layer = cc.Layer:create()
    local bg = cc.Sprite:create(mapInfo:GetMapName())
    --local bg = CCSprite:create("farm.jpg")
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local originSize = cc.Director:getInstance():getVisibleOrigin()
    bg:setPosition(originSize.x+visibleSize.width/2, originSize.y+visibleSize.height/2)
    
    layer:addChild(bg)
    
    local bgSize = bg:getContentSize()
    print("bg Size:", bgSize.width, bgSize.height)
    
    local function OnTouchEvent(eventType, x, y)
        print("Touch Event", eventType, x, " ", y)
    end
    
    layer:registerScriptTouchHandler(OnTouchEvent)
    layer:setTouchEnabled(true)
    
    local function MaterialPos2CocosPercent(x, y, width, height)
        return x/width, 1-y/height
    end
    
    require ("Car341")
    require ("Car342")
    
    local carName = Car341Name
    local carAnchorPosX, carAnchorPosY = unpack(Car341AnchorPoint)
    local carWidth, carHeight = unpack(Car341Size)
    local carAnchorP1, carAnchorP2 = MaterialPos2CocosPercent(carAnchorPosX, carAnchorPosY, carWidth, carHeight)
    local carAnchorPercent = {carAnchorP1, carAnchorP2}
    local V = Car341V
    local car2Name = Car342Name
    local car2AnchorPosX, car2AnchorPosY = unpack(Car342AnchorPoint)
    local car2Width, car2Height = unpack(Car342Size)
    local car2AnchorP1, car2AnchorP2 = MaterialPos2CocosPercent(car2AnchorPosX, car2AnchorPosY, car2Width, car2Height)
    local car2AnchorPercent = {car2AnchorP1, car2AnchorP2}
    local V2 = Car342V
    local cars = {}
    local roadInfo = {}
    
    
    
    local map_w, map_h = mapInfo:GetMapSize()
    
    local function MaterialPos2ViewPos(x,y)
        local relativeX = x*(bgSize.width/map_w)
        local relativeY = y*(bgSize.height/map_h)
        return {relativeX-(bgSize.width/2-visibleSize.width/2), bgSize.height-relativeY-(bgSize.height/2-visibleSize.height/2)}
    end
    
    local function ViewPos2ScenePos(x,y)
        return {x+(bgSize.width/2-visibleSize.width/2), y+(bgSize.height/2-visibleSize.height/2)}
    end
    
    print("OpenGL Size:", originSize.x, originSize.y, visibleSize.width, visibleSize.height)
    
    
    
    local function BuildRoad(mapInfo)
        for index,st_end in pairs(mapInfo:GetRoadInfo()) do
            local startP,endP = st_end[1], st_end[2]
            local sceneStart, sceneEnd = MaterialPos2ViewPos(unpack(startP)), MaterialPos2ViewPos(unpack(endP))
            local dirVec = {sceneEnd[1]-sceneStart[1], sceneEnd[2]-sceneStart[2]}
            local len = math.sqrt((dirVec[1]*dirVec[1]+ dirVec[2]*dirVec[2]))
            local dirUnitVec = {dirVec[1]/len, dirVec[2]/len}
            roadInfo[index] = {sceneStart, sceneEnd, dirUnitVec}
        end
    end
    
    
    BuildRoad(mapInfo)
    
    local function IsInScene(x,y)
        x,y = unpack(ViewPos2ScenePos(x,y))
        return (x>=0) and (x<=bgSize.width) and (y>=0) and (y<=bgSize.height)
    end
    
    local function Distance(x1, y1, x2, y2)
        local x = x1-x2
        local y = y1-y2
        return math.sqrt(x*x+y*y)
    end
    
    local lastCarbornTime = os.time()
    
    local function Update(deltaT)
        for car,_ in pairs(cars) do
            local origPosX, origPosY = car:getPosition()
            if not (IsInScene(origPosX, origPosY)) then
                cars[car]=nil
                --layer:removeChild(car, true)
                --print("Cleanup")
                car:removeFromParent()
            else
                --local v, roadIdx = unpack(cars[car])
                --local dirUnitVec = roadInfo[roadIdx][3]
                --car:setPosition(origPosX+v*dirUnitVec[1]*deltaT, origPosY+v*dirUnitVec[2]*deltaT)
            end
        end
        if (math.random()<0.5) then
            if (os.time()-lastCarbornTime < 1) then return end
            lastCarbornTime = os.time()
            
            local index, l_carName, l_carAnchorPercent = nil, nil, nil
            local l_carW, l_carH = nil, nil
            local l_V = nil
            index = math.random(2)
            if index == 1 then
                l_carName = carName
                l_carAnchorPercent = carAnchorPercent
                l_carW,l_carH = carWidth, carHeight
                l_V = V
            else
                l_carName = car2Name
                l_carAnchorPercent = car2AnchorPercent
                l_carW, l_carH = car2Width, car2Height
                l_V = V2
            end
            
            local newCar = cc.Sprite:create(l_carName)


                                                         
            newCar:setAnchorPoint(unpack(l_carAnchorPercent))
            print("car anchor pos:", unpack(l_carAnchorPercent))
            
            local carBornPoses = CScene548:GetCarBornPos()
            local carBornPos = nil
            if #carBornPoses > 1 then
                --carBornPos = carBornPoses[math.random(#carBornPoses)]
                carBornPos = carBornPoses[index]
            else
                carBornPos = carBornPoses[1]
            end
            local bornPosInScene = MaterialPos2ViewPos(carBornPos[1], carBornPos[2])
            print("car born pos:", unpack(bornPosInScene))
            newCar:setPosition(bornPosInScene[1], bornPosInScene[2])
            layer:addChild(newCar)
            cars[newCar] = {l_V, carBornPos[3]}
            local roadIdx = carBornPos[3]
            local roadEndX, roadEndY = roadInfo[roadIdx][2][1], roadInfo[roadIdx][2][2]
            local destPos = cc.p(roadEndX, roadEndY)
            local moveAction = cc.MoveTo:create(5, destPos)
            local moveEndFunc = cc.CallFunc:create(function()
                                                   newCar:removeFromParent()
                                                   cars[newCar] = nil
                                                   print("Move End and cleanup")
                                                   end)
            --local seqArg = {moveAction, moveEndFunc}
            --local seq = transition.sequence(seqArg)
            --newCar:runAction(seq)
            
            local Vx, Vy = roadEndX-bornPosInScene[1], roadEndY-bornPosInScene[2]
            local d = math.sqrt(Vx*Vx+Vy*Vy)
            Vx, Vy = Vx*l_V/d, Vy*l_V/d
            
            local physicsBody = cc.PhysicsBody:createBox({["width"]=l_carW, ["height"]=l_carH})
            physicsBody:setGravityEnable(false)
            physicsBody:setVelocity(cc.p(Vx, Vy))
            physicsBody:setContactTestBitmask(1)
            newCar:setPhysicsBody(physicsBody)
        end
    end
    
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(Update, 0, false)
    
    self:addChild(layer)
    
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0,0))
    
    self.contactListener = cc.EventListenerPhysicsContact:create()
    self.contactListener:registerScriptHandler( function (contact)
                                          print("Contact", contact)
                                          end, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(self.contactListener, self);
    --cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.contactListener, layer)

    self:getPhysicsWorld():setDebugDrawMask(
        true and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
end

function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
