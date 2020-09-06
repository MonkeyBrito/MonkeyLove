local MonkeyLove = require "monkeylove"

local SW, SH = love.graphics.getDimensions()
local image = love.graphics.newImage('Boton200x50.png')
local font = love.graphics.newFont(15)
local txt1 = "I'm a label"
local txt2 = "I'm a Secret label"
local limit1 = font:getWidth(txt1)
local limit2 = font:getWidth(txt2)
local B1X, B1Y = SW - 200, 5
local B2X, B2Y = 5, 5
local LX1, LY1, LX2, LY2 = SW/2 - limit1/2, 5, SW/2 - limit2/2, 45
local ETX, ETY, ETW = 35, 75, SW/2 - 75
local PBX, PBY, PBW = 10, 140, SW/2 - 20
local SDX, SDY, SDW = SW/2 + 100, 90, SW/2 - 200
local SPX, SPY, SPW, SPH = SW/2 + 76, 140, SW/2 - 152, 50
local options = {'Option 1', 'Option 2', 'Option 3'}
--local Ar, AX, AY = 50, SW, SH-25

function toggleAll()
	B2:toggleEnabled()
	ET:toggleEnabled()
	PB:togglePaused()
	SD:toggleEnabled()
	SP:toggleEnabled()
	Analog:toggleEnabled()
	Gamepad:toggleEnabled()
end

function love.load()
	Gamepad:setGamepad(nil, 4)
	START = Gamepad:new(nil,SW/2,SH-30,'START')
	AL = Analog:new(50,nil,AX,AY)
	B1 = Button:new(image,nil,nil,B1X,B1Y,'Disable',function() toggleAll() end,nil,nil,nil,function() toggleAll() end,'Enable')
	B2 = Button:new(image,nil,nil,B2X,B2Y,'GREEN',function() love.graphics.setBackgroundColor(colors('GREEN')) end,nil,nil,nil,function() love.graphics.setBackgroundColor(colors('BLACK')) end,'BLACK')
	ET = EditText:new(ETX,ETY,ETW,'left',font)
	PB = ProgressBar:new(PBX,PBY,PBW,50,100,0,'Loading ','%',font)
	SD = Slider:new(SDX,SDY,SDW)
	SP = Stepper:new(SPX,SPY,SPW,SPH,'<','>',3,options,1,true,1,nil,font)
end

function love.update(dt)
	MonkeyLove:update(dt)
	PB:IncreaseProgress(1)
	alpha = 1 - SD:cursorValue()
	if SP:currentSelection() == 'Option 1' then
		fontColor = 'WHITE'
	elseif SP:currentSelection() == 'Option 2' then
		fontColor = 'FUCHSIA'
	elseif SP:currentSelection() == 'Option 3' then
		fontColor = 'YELLOW'
	end
end

function love.draw()
	MonkeyLove:draw()
	love.graphics.setColor(colors(fontColor, alpha))
	setLabel(txt1,font,LX1,LY1,limit1,50,'center')
	love.graphics.setColor(colors(fontColor, SD:cursorValue()))
	setLabel(txt2,font,LX2,LY2,limit2,50,'center')
end

function love.textinput(text)
	MonkeyLove:textinput(text)
end

function love.keypressed(key,scancode,isrepeat)
	MonkeyLove:keypressed(key,scancode,isrepeat)
end

function love.touchpressed(id,x,y)
	MonkeyLove:touchpressed(id,x,y)
end

function love.touchmoved(id,x,y)
	MonkeyLove:touchmoved(id,x,y)
end

function love.touchreleased(id,x,y)
	MonkeyLove:touchreleased(id,x,y)
end
