--! file: Map.lua
 
Map = Object.extend(Object)
 
function Map:new()
    self.map = {}
    self.map.width = 0
    self.map.height = 0
    self.map.nodeData = {}
end