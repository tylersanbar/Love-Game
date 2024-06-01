local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
	require("lldebugger").start()

	function love.errorhandler(msg)
		error(msg, 2)
	end
end

require "src/Globals"

function love.load()
	SceneManager:load()
end

function love.update(dt)
	SceneManager:update(dt)
end

function love.draw()
	SceneManager:draw()
end

function love.keypressed(key)
	SceneManager:keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
	SceneManager:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	SceneManager:mousereleased(x, y, button, istouch, presses)
end