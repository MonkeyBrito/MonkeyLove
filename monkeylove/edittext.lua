local EditText = {
	_NAME        = "MonkeyLove EditText",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'EditText for input text in love2d games and apps',
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
	]]
}

--local current_folder = (...):gsub('%.[^%.]+$', '')

local utf8 = require "utf8"

local EditText = class('EditText')

local lineWidth = defaultLineWidth() * 2
local __edittexts = {}

function EditText:initialize(x,y,w,align,font,lineColor,focusColor,fontColor,callback,customtext,filter)
	self.x = x
	self.y = y

	self.font = font or love.graphics.getFont()
	self.w = w
	self.h = self.font:getHeight() * 1.5

	self.xo = self.x - 4
	self.xl = self.x + self.w + 4
	self.yl = self.y + self.h
	
	self.text = customtext or ''
	self.align = align or 'left'
	
	self.cursor = '|'
	self.time = 0.0
	self.cursorWidth = self.font:getWidth('|')
	self.cursorHalfWidth = self.cursorWidth/2
	self.cursorPos = self.x + self.font:getWidth(self.text) - self.cursorHalfWidth
	
	self.returncallback = callback or function() end
	
	self.lineColor = lineColor or colors('CUSTOM CYAN')
	self.focusColor = focusColor or colors('CYAN')
	self.fontColor = fontColor or colors('WHITE')
	self.currentLineColor = self.lineColor
	self.currentFocusColor = self.focusColor
	self.currentFontColor = self.fontColor
	self.disabledColor = grayscale(0.2)
--	self.boxColor = grayscale(32/255)
	
	self.filter = filter or ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ÑñÁáÉéÍíÓóÚúÖöÜü¡!¿?'
	
	self.enabled = true
	self.focus = false
	
	table.insert(__edittexts,self)
end

function EditText:toggleEnabled()
	self.enabled = not self.enabled
	if self.enabled then
		self.currentLineColor = self.lineColor
		self.currentFocusColor = self.focusColor
		self.currentFontColor = self.fontColor
--		self.boxColor = grayscale(32/255)
	else
	self.currentLineColor = self.disabledColor
	self.currentFocusColor = self.disabledColor
	self.currentFontColor = self.disabledColor
--		self.boxColor = self.disabledColor
	self.focus = false
	love.keyboard.setTextInput(self.focus,self.x,self.y,self.w,self.h)
	end
end

function EditText:textinput(text)
	for i,v in ipairs(__edittexts) do
		if v.enabled then
			if v.focus then
				if v.font:getWidth(v.text) <= v.w - v.cursorWidth*2 then
					v.text = v.text .. (text or '')
					v.text = v.text:gsub("[^" .. v.filter .. "]","")
				end
			end
		end
	end
end

function EditText:keypressed(key,scancode,isrepeat)
	for i,v in ipairs(__edittexts) do
		if v.enabled then
			if v.focus then
				if key == 'backspace' then
					-- get the byte offset to the last UTF-8 character in the string.
					local byteoffset = utf8.offset(v.text, -1)

					if byteoffset then
						-- remove the last UTF-8 character.
						-- string.sub operates on bytes rather than UTF-8 characters, 
						--so we couldn't do string.sub(text, 1, -2).
						v.text = v.text:sub(1, byteoffset - 1)
					end
				elseif key == 'return' then  --Tecla Enter
					v.returncallback()
				elseif key == 'escape' then
					v.focus = false
					love.keyboard.setTextInput(v.focus,v.x,v.y,v.w,v.h)
				end
			end
		end
	end
end

function EditText:update(dt)
	for i,v in ipairs(__edittexts) do
		if v.enabled then
			if v.focus then
				v.time = v.time + dt
				if v.time > 0.5 then
					if v.cursor == '|' then
						v.cursor = ''
					else
						v.cursor = '|'
					end
					v.time = 0.0
				end
				v.cursorPos = v.x + v.font:getWidth(v.text) - v.cursorHalfWidth
			end
		end
	end
end

function EditText:draw()
	for i,v in ipairs(__edittexts) do
		if v.focus then
			love.graphics.setColor(v.currentFontColor)
			setLabel(v.cursor,v.font,v.cursorPos,v.y,v.w,v.h,v.align)
			love.graphics.setColor(v.currentFocusColor)
		else
			love.graphics.setColor(v.currentLineColor)
		end
		love.graphics.setLineWidth(lineWidth)
		love.graphics.line(v.xo,v.yl,v.xl,v.yl)
		love.graphics.setLineWidth(defaultLineWidth())
		
		love.graphics.setColor(v.currentFontColor)
		setLabel(v.text,v.font,v.x,v.y,v.w,v.h,v.align)
		
--		love.graphics.setColor(v.boxColor)
--		love.graphics.rectangle("fill",v.x,v.y,v.w,v.h)
		love.graphics.setColor(colors('WHITE'))
	end
end

function EditText:touchpressed(id,tx,ty)
	for i,v in ipairs(__edittexts) do
		if v.enabled then
			if isInsideBoundingBox(v,tx,ty) then
				v.focus = true
				love.keyboard.setTextInput(v.focus,v.x,v.y,v.w,v.h)
			elseif not isInsideBoundingBox(v,tx,ty) and v.focus then
				v.focus = false
				love.keyboard.setTextInput(v.focus,v.x,v.y,v.w,v.h)
			end
		end
	end
end

return EditText
