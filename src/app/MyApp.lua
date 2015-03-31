
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/app/")
    --cc.FileUtils:getInstance():addSearchPath("src/app/model/")
    --self:enterScene("PlayScene", {"Scene548"})
    self:enterScene("DustScene", {})
end

return MyApp
