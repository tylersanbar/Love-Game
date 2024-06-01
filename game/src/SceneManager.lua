-- SceneManager.lua
SceneManager = Object:extend()

--! file: MainMenu.lua

-- Pass Object as first argument.
SceneManager = Object.extend(Object)

function SceneManager:new()
    self.scenes = {}
    self.currentScene = nil
end

function SceneManager:load()
    SceneManager:add("mainmenu", MainMenu())
    SceneManager:add("game", GameScene())
    SceneManager:switch("mainmenu")
end

function SceneManager:add(name, scene)
    self.scenes[name] = scene
end

function SceneManager:switch(name, ...)
    assert(self.scenes[name], "Scene " .. name .. " does not exist")
    self.currentScene = self.scenes[name]
    if self.currentScene.load then
        self.currentScene:load(...)
    end
end

function SceneManager:update(dt)
    if self.currentScene and self.currentScene.update then
        self.currentScene:update(dt)
    end
end

function SceneManager:draw()
    if self.currentScene and self.currentScene.draw then
        self.currentScene:draw()
    end
end

function SceneManager:keypressed(key)
    if self.currentScene and self.currentScene.keypressed then
        self.currentScene:keypressed(key)
    end
end

function SceneManager:mousepressed(x, y, button, istouch, presses)
    if self.currentScene and self.currentScene.mousepressed then
        self.currentScene:mousepressed(x, y, button, istouch, presses)
    end
end

function SceneManager:mousereleased(x, y, button, istouch, presses)
    if self.currentScene and self.currentScene.mousereleased then
        self.currentScene:mousereleased(x, y, button, istouch, presses)
    end
end

return SceneManager
