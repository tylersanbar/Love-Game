--! file: MainMenu.lua

-- Pass Object as first argument.
MainMenu = Object.extend(Object)

function MainMenu.new(self)
    self.name = "mainmenu"
end

function MainMenu.load(self)
    self.title = "Space Wars"
    self.subtitle = "Press Enter to start"
end

function MainMenu.update(self, dt)
    if(love.keyboard.isDown("return")) then
        SceneManager:switch("game")
    end
end

function MainMenu.draw(self)
    love.graphics.setColor(COLORS.white)
    love.graphics.printf(self.title, 0, 100, 100, "center")
    love.graphics.printf(self.subtitle, 0, 200, 100, "center")
end