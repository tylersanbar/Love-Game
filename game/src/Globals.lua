COLORS = {
        purple = {0.5, 0, 0.5, 1},
        green = {0, 1, 0, 1},
        white = {1, 1, 1, 1},
        black = {0, 0, 0, 1},
        red = {1, 0, 0, 1},
        blue = {0, 0, 1, 1},
    }
CATEGORIES = {
        ship = 1,
        harbor = 2,
        node = 3,
        team1 = 4,
        team2 = 5
    }


Object = require "lib/classic"
Inspect = require "lib/inspect"
require "src/SceneManager"
SceneManager = SceneManager()
require "src/scenes/MainMenu"
require "src/scenes/GameScene"
require "lib/arrow"
require "src/Game"
require "src/GameObjects/Ship"
require "src/GameObjects/Node"
require "src/GameObjects/HarborCollection"
require "src/GameObjects/Harbor"
require "src/GameObjects/Arrow"
M = require "lib/mahth"