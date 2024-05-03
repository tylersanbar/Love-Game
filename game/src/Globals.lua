function Game:set_globals()
    self.C = {
        purple = {0.5, 0, 0.5, 1},
        green = {0, 1, 0, 1},
        white = {1, 1, 1, 1},
        black = {0, 0, 0, 1},
        red = {1, 0, 0, 1},
        blue = {0, 0, 1, 1},
    }
    self.CATEGORIES = {

        ship = 1,
        harbor = 2,
        node = 3,
        team1 = 4,
        team2 = 5
    }
end

M = require "lib/mahth"
G = Game()