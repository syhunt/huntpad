-- Huntpad extension pack for the Sandcat Browser
Huntpad = extensionpack:new()
Huntpad.filename = 'Huntpad.scx'

function Huntpad:init()
end

function Huntpad:afterinit()
 self:dofile('quickinject/quickinject.lua')
 quickinject:add()
end