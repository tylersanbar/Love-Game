local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
	require("lldebugger").start()

	function love.errorhandler(msg)
		error(msg, 2)
	end
end

Object = require "lib/classic"
Inspect = require "lib/inspect"
require "lib/arrow"
require "src/Game"
require "src/Globals"
require "src/GameObjects/Ship"
require "src/GameObjects/Node"
require "src/GameObjects/Harbor"
require "src/GameObjects/Arrow"

function love.load()
	G:startDemo()
end

function love.update(dt)
	G:update(dt)
end

function love.draw()
	G:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
	G:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	G:mousereleased(x, y, button, istouch, presses)
end