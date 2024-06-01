--! file: GameScene.lua

-- Pass Object as first argument.
GameScene = Object.extend(Object)

function GameScene.new(self)
    self.name = "game"
end

function GameScene.load(self)
    G = Game()
end

function GameScene.update(self, dt)
    G:update(dt)
end

function GameScene.draw(self)
    G:draw()
end

function GameScene.keypressed(key)
	G:keypressed(key)
end

function GameScene.mousepressed(x, y, button, istouch, presses)
	G:mousepressed(x, y, button, istouch, presses)
end

function GameScene.mousereleased(x, y, button, istouch, presses)
	G:mousereleased(x, y, button, istouch, presses)
end