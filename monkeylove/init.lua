local MonkeyLove = {
	_NAME        = "MonkeyLove",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'MonkeyLove Library',
	_URL         = 'https://github.com/MonkeyBrito/MonkeyLove',
	_LICENSE     = [[
	MIT LICENSE
	
	Copyright (c) 2020 Eduardo Brito Rosas

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	]],
	_CREDITS     = [[
	Credits to "HugoBDesigner" for his awasome "Andralog - Analog control for
	android" and "kikito" for "middleclass" his great object-orientation 
	module for Lua.
	]]
}

local current_folder = (...):gsub('%.init$', '') -- "my-package"

-- Third-party modules:
class       = require (current_folder .. '.third-party.middleclass.middleclass')

-- MonkeyLove modules:
Tools       = require (current_folder .. '.tools')
Analog      = require (current_folder .. '.analog')
Gamepad     = require (current_folder .. '.gamepad')
Button      = require (current_folder .. '.button')
EditText    = require (current_folder .. '.edittext')
ProgressBar = require (current_folder .. '.progressbar')
Slider      = require (current_folder .. '.slider')
Stepper     = require (current_folder .. '.stepper')

local MonkeyLove = {}

function MonkeyLove:update(dt)
	Analog:update(dt)
	Button:update(dt)
	EditText:update(dt)
	Slider:update(dt)
end

function MonkeyLove:draw()
	Analog:draw()
	Gamepad:draw()
	Button:draw()
	EditText:draw()
	ProgressBar:draw()
	Slider:draw()
	Stepper:draw()
end

function MonkeyLove:touchpressed(id,tx,ty)
	Analog:touchpressed(id,tx,ty)
	Gamepad:touchpressed(id,tx,ty)
	Button:touchpressed(id,tx,ty)
	EditText:touchpressed(id,tx,ty)
	Slider:touchpressed(id,tx,ty)
end

function MonkeyLove:touchmoved(id,tx,ty)
	Analog:touchmoved(id,tx,ty)
	Slider:touchmoved(id,tx,ty)
end

function MonkeyLove:touchreleased(id,tx,ty)
	Analog:touchreleased(id,tx,ty)
	Gamepad:touchreleased(id,tx,ty)
	Button:touchreleased(id,tx,ty)
	Slider:touchreleased(id,tx,ty)
end

function MonkeyLove:textinput(text)
	EditText:textinput(text)
end

function MonkeyLove:keypressed(key,scancode,isrepeat)
	EditText:keypressed(key,scancode,isrepeat)
end

return MonkeyLove
