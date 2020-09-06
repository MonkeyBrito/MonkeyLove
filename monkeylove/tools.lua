local Tools = {
	_NAME        = "MonkeyLove Tools",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'Tools for MonkeyLove Library',
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

--(Lua types: nil, boolean, number, string, function, userdata, thread y table).

--Return(number). Reminder of the default line width.
function defaultLineWidth()
	return 1
end

--Return(boolean). Return true if the touch is inside of a given rectangle.
function isInsideBoundingBox(self, tx, ty)
	return self.x <= tx and tx <= self.x + self.w and self.y <= ty and ty <= self.y + self.h
end

--Return(boolean). Return true if the touch is inside of a given circle.
function isInsideCircle(self, tx, ty)
	local distance = getDistance(tx, ty, self.x, self.y)
	return distance < self.radius
end

--Return(number). Angle in radians given 2 points. --Put Self?
function getAngle(x2, y2, x1, y1)
	local a = math.atan2(y2-y1, x2-x1)
	a = -a
	while a < 0 do
		a = a + math.pi*2
	end
	while a >= math.pi*2 do
		a = a - math.pi*2
	end
	return a
end

--Return(number). Distance between 2 points. --Put Self?
function getDistance(x2, y2, x1, y1)
	return math.sqrt( math.abs(x2 - x1)^2 + math.abs(y2 - y1)^2 )
end

--Return(number). Vertical offset used for center a text line.
function getFontYOffset(y, height)
	local font = love.graphics.getFont()
	if font then
		return y + (height/2) - (font:getHeight()/2)
	end
	return 0
end

--Return(function). Draw a customizable label. 
function setLabel(text, font, x, y, limit, height, align, r, sx, sy, ox, oy, kx, ky)
	return love.graphics.printf(text, font, x, getFontYOffset(y, height), limit, align, r, sx, sy, ox, oy, kx, ky)
end

--Return(function). Load and set a font.
--[!!!]Don't use this function inside of draw or update, because can cause slow downs.
function setFont(name, size)
	return love.graphics.setFont(love.graphics.newFont('assets/font' .. name .. '.ttf',size))
end

--Return(table). Allow to use web notation of colors.(0-255, alpha default to 255).
function rgb(r, g, b, a)
    a = a or 255
    return {r/255, g/255, b/255, a/255}
end

--Return(table). Return grayscale color, 0=Black y 1=White.
function grayscale(level, alpha)
    return {level, level, level, alpha or 255}
end

--Return(table), of a already preset color.
function colors(color, alpha)
	--138 different colors.
	if color == 'BLACK' then
		return {0,0,0,alpha or 1}
	elseif color == 'WHITE' then
		return {1,1,1,alpha or 1}
	elseif color == 'RED' then
		return {1,0,0,alpha or 1}
	elseif color == 'LIME' then
		return {0,1,0,alpha or 1}
	elseif color == 'BLUE' then
		return {0,0,1,alpha or 1}
	elseif color == 'YELLOW' then
		return {1,1,0,alpha or 1}
	elseif color == 'CYAN' or color == 'AQUA' then
		return {0,1,1,alpha or 1}
	elseif color == 'FUCHSIA' or color == 'MAGENTA' then
		return {1,0,1,alpha or 1}
	elseif color == 'MAROON' then
		return {128/255,0,0,alpha or 1}
	elseif color == 'OLIVE' then
		return {128/255,128/255,0,alpha or 1}
	elseif color == 'GREEN' then
		return {0,128/255,0,alpha or 1}
	elseif color == 'TEAL' then
		return {0,128/255,128/255,alpha or 1}
	elseif color == 'NAVY' then
		return {0,0,128/255,alpha or 1}
	elseif color == 'PURPLE' then
		return {128/255,0,128/255,alpha or 1}
--------------------------------------------------------------
	elseif color == 'DARK RED' then
		return {139/255,0/255,0/255,alpha or 1}
	elseif color == 'BROWN' then
		return {165/255,42/255,42/255,alpha or 1}
	elseif color == 'FIREBRICK' then
		return {178/255,34/255,34/255,alpha or 1}
	elseif color == 'CRIMSON' then
		return {220/255,20/255,60/255,alpha or 1}
	elseif color == 'TOMATO' then
		return {255/255,99/255,71/255,alpha or 1}
	elseif color == 'CORAL' then
		return {255/255,127/255,80/255,alpha or 1}
	elseif color == 'INDIAN RED' then
		return {205/255,92/255,92/255,alpha or 1}
	elseif color == 'LIGHT CORAL' then
		return {240/255,128/255,128/255,alpha or 1}	
	elseif color == 'DARK SALMON' then
		return {233/255,150/255,122/255,alpha or 1}	
	elseif color == 'SALMON' then
		return {250/255,128/255,114/255,alpha or 1}	
	elseif color == 'LIGHT SALMON' then
		return {255/255,160/255,122/255,alpha or 1}	
	elseif color == 'ORANGE RED' then
		return {255/255,69/255,0/255,alpha or 1}	
	elseif color == 'DARK ORANGE' then
		return {255/255,140/255,0/255,alpha or 1}	
	elseif color == 'ORANGE' then
		return {255/255,165/255,0/255,alpha or 1}	
	elseif color == 'GOLD' then
		return {255/255,215/255,0/255,alpha or 1}	
	elseif color == 'DARK GOLDEN ROD' then
		return {184/255,134/255,11/255,alpha or 1}	
	elseif color == 'GOLDEN ROD' then
		return {218/255,165/255,32/255,alpha or 1}	
	elseif color == 'PALE GOLDEN ROD' then
		return {238/255,232/255,170/255,alpha or 1}	
	elseif color == 'DARK KHAKI' then
		return {189/255,183/255,107/255,alpha or 1}	
	elseif color == 'KHAKI' then
		return {240/255,230/255,140/255,alpha or 1}	
	elseif color == 'YELLOW GREEN' then
		return {154/255,205/255,50/255,alpha or 1}	
	elseif color == 'DARK OLIVE GREEN' then
		return {85/255,107/255,47/255,alpha or 1}	
	elseif color == 'OLIVE DRAB' then
		return {107/255,142/255,35/255,alpha or 1}	
	elseif color == 'LAWN GREEN' then
		return {124/255,252/255,0/255,alpha or 1}	
	elseif color == 'CHART REUSE' then
		return {127/255,255/255,0/255,alpha or 1}	
	elseif color == 'GREEN YELLOW' then
		return {173/255,255/255,47/255,alpha or 1}	
	elseif color == 'DARK GREEN' then
		return {0/255,100/255,0/255,alpha or 1}	
	elseif color == 'FOREST GREEN' then
		return {34/255,139/255,34/255,alpha or 1}	
	elseif color == 'LIME GREEN' then
		return {50/255,205/255,50/255,alpha or 1}	
	elseif color == 'LIGHT GREEN' then
		return {144/255,238/255,144/255,alpha or 1}	
	elseif color == 'PALE GREEN' then
		return {152/255,251/255,152/255,alpha or 1}	
	elseif color == 'DARK SEA GREEN' then
		return {143/255,188/255,143/255,alpha or 1}	
	elseif color == 'MEDIUM SPRING GREEN' then
		return {0/255,250/255,154/255,alpha or 1}	
	elseif color == 'SPRING GREEN' then
		return {0/255,255/255,127/255,alpha or 1}	
	elseif color == 'SEA GREEN' then
		return {46/255,139/255,87/255,alpha or 1}	
	elseif color == 'MEDIUM AQUA MARINE' then
		return {102/255,205/255,170/255,alpha or 1}	
	elseif color == 'MEDIUM SEA GREEN' then
		return {60/255,179/255,113/255,alpha or 1}	
	elseif color == 'LIGHT SEA GREEN' then
		return {32/255,178/255,170/255,alpha or 1}	
	elseif color == 'DARK SLATE GRAY' then
		return {47/255,79/255,79/255,alpha or 1}	
	elseif color == 'DARK CYAN' then
		return {0/255,139/255,139/255,alpha or 1}		
	elseif color == 'LIGHT CYAN' then
		return {224/255,255/255,255/255,alpha or 1}	
	elseif color == 'DARK TURQUOISE' then
		return {0/255,206/255,209/255,alpha or 1}	
	elseif color == 'TURQUOISE' then
		return {64/255,224/255,208/255,alpha or 1}	
	elseif color == 'MEDIUM TURQUOISE' then
		return {72/255,209/255,204/255,alpha or 1}	
	elseif color == 'PALE TURQUOISE' then
		return {175/255,238/255,238/255,alpha or 1}	
	elseif color == 'AQUA MARINE' then
		return {127/255,255/255,212/255,alpha or 1}	
	elseif color == 'POWDER BLUE' then
		return {176/255,224/255,230/255,alpha or 1}	
	elseif color == 'CADET BLUE' then
		return {95/255,158/255,160/255,alpha or 1}	
	elseif color == 'STEEL BLUE' then
		return {70/255,130/255,180/255,alpha or 1}	
	elseif color == 'CORN FLOWER BLUE' then
		return {100/255,149/255,237/255,alpha or 1}	
	elseif color == 'DEEP SKY BLUE' then
		return {0/255,191/255,255/255,alpha or 1}	
	elseif color == 'DODGER BLUE' then
		return {30/255,144/255,255/255,alpha or 1}	
	elseif color == 'LIGHT BLUE' then
		return {173/255,216/255,230/255,alpha or 1}	
	elseif color == 'SKY BLUE' then
		return {135/255,206/255,235/255,alpha or 1}	
	elseif color == 'LIGHT SKY BLUE' then
		return {135/255,206/255,250/255,alpha or 1}	
	elseif color == 'MIDNIGHT BLUE' then
		return {25/255,25/255,112/255,alpha or 1}	
	elseif color == 'DARK BLUE' then
		return {0/255,0/255,139/255,alpha or 1}	
	elseif color == 'MEDIUM BLUE' then
		return {0/255,0/255,205/255,alpha or 1}	
	elseif color == 'ROYAL BLUE' then
		return {65/255,105/255,225/255,alpha or 1}	
	elseif color == 'BLUE VIOLET' then
		return {138/255,43/255,226/255,alpha or 1}	
	elseif color == 'INDIGO' then
		return {75/255,0/255,130/255,alpha or 1}	
	elseif color == 'DARK SLATE BLUE' then
		return {72/255,61/255,139/255,alpha or 1}	
	elseif color == 'SLATE BLUE' then
		return {106/255,90/255,205/255,alpha or 1}	
	elseif color == 'MEDIUM SLATE BLUE' then
		return {123/255,104/255,238/255,alpha or 1}	
	elseif color == 'MEDIUM PURPLE' then
		return {147/255,112/255,219/255,alpha or 1}	
	elseif color == 'DARK MAGENTA' then
		return {139/255,0/255,139/255,alpha or 1}	
	elseif color == 'DARK VIOLET' then
		return {148/255,0/255,211/255,alpha or 1}	
	elseif color == 'DARK ORCHID' then
		return {153/255,50/255,204/255,alpha or 1}	
	elseif color == 'MEDIUM ORCHID' then
		return {186/255,85/255,211/255,alpha or 1}	
	elseif color == 'THISTLE' then
		return {216/255,191/255,216/255,alpha or 1}	
	elseif color == 'PLUM' then
		return {221/255,160/255,221/255,alpha or 1}	
	elseif color == 'VIOLET' then
		return {238/255,130/255,238/255,alpha or 1}	
	elseif color == 'ORCHID' then
		return {218/255,112/255,214/255,alpha or 1}	
	elseif color == 'MEDIUM VIOLET RED' then
		return {199/255,21/255,133/255,alpha or 1}	
	elseif color == 'PALE VIOLET RED' then
		return {219/255,112/255,147/255,alpha or 1}	
	elseif color == 'DEEP PINK' then
		return {255/255,20/255,147/255,alpha or 1}	
	elseif color == 'HOT PINK' then
		return {255/255,105/255,180/255,alpha or 1}	
	elseif color == 'LIGHT PINK' then
		return {255/255,182/255,193/255,alpha or 1}	
	elseif color == 'PINK' then
		return {255/255,192/255,203/255,alpha or 1}	
	elseif color == 'ANTIQUE WHITE' then
		return {250/255,235/255,215/255,alpha or 1}	
	elseif color == 'BEIGE' then
		return {245/255,245/255,220/255,alpha or 1}	
	elseif color == 'BISQUE' then
		return {255/255,228/255,196/255,alpha or 1}	
	elseif color == 'BLANCHED ALMOND' then
		return {255/255,235/255,205/255,alpha or 1}	
	elseif color == 'WHEAT' then
		return {245/255,222/255,179/255,alpha or 1}	
	elseif color == 'CORN SILK' then
		return {255/255,248/255,220/255,alpha or 1}	
	elseif color == 'LEMON CHIFFON' then
		return {255/255,250/255,205/255,alpha or 1}	
	elseif color == 'LIGHT GOLDEN ROD YELLOW' then
		return {250/255,250/255,210/255,alpha or 1}	
	elseif color == 'LIGHT YELLOW' then
		return {255/255,255/255,224/255,alpha or 1}	
	elseif color == 'SADDLE BROWN' then
		return {139/255,69/255,19/255,alpha or 1}	
	elseif color == 'SIENNA' then
		return {160/255,82/255,45/255,alpha or 1}	
	elseif color == 'CHOCOLATE' then
		return {210/255,105/255,30/255,alpha or 1}	
	elseif color == 'PERU' then
		return {205/255,133/255,63/255,alpha or 1}	
	elseif color == 'SANDY BROWN' then
		return {244/255,164/255,96/255,alpha or 1}
	elseif color == 'BURLY WOOD' then
		return {222/255,184/255,135/255,alpha or 1}
	elseif color == 'TAN' then
		return {210/255,180/255,140/255,alpha or 1}
	elseif color == 'ROSY BROWN' then
		return {188/255,143/255,143/255,alpha or 1}
	elseif color == 'MOCCASIN' then
		return {255/255,228/255,181/255,alpha or 1}
	elseif color == 'NAVAJO WHITE' then
		return {255/255,222/255,173/255,alpha or 1}
	elseif color == 'PEACH PUFF' then
		return {255/255,218/255,185/255,alpha or 1}
	elseif color == 'MISTY ROSE' then
		return {255/255,228/255,225/255,alpha or 1}
	elseif color == 'LAVENDER BLUSH' then
		return {255/255,240/255,245/255,alpha or 1}
	elseif color == 'LINEN' then
		return {250/255,240/255,230/255,alpha or 1}
	elseif color == 'OLD LACE' then
		return {253/255,245/255,230/255,alpha or 1}
	elseif color == 'PAPAYA WHIP' then
		return {255/255,239/255,213/255,alpha or 1}
	elseif color == 'SEA SHELL' then
		return {255/255,245/255,238/255,alpha or 1}
	elseif color == 'MINT CREAM' then
		return {245/255,255/255,250/255,alpha or 1}
	elseif color == 'SLATE GRAY' then
		return {112/255,128/255,144/255,alpha or 1}
	elseif color == 'LIGHT SLATE GRAY' then
		return {119/255,136/255,153/255,alpha or 1}
	elseif color == 'LIGHT STEEL BLUE' then
		return {176/255,196/255,222/255,alpha or 1}
	elseif color == 'LAVENDER' then
		return {230/255,230/255,250/255,alpha or 1}
	elseif color == 'FLORAL WHITE' then
		return {255/255,250/255,240/255,alpha or 1}
	elseif color == 'ALICE BLUE' then
		return {240/255,248/255,255/255,alpha or 1}
	elseif color == 'GHOST WHITE' then
		return {248/255,248/255,255/255,alpha or 1}
	elseif color == 'HONEYDEW' then
		return {240/255,255/255,240/255,alpha or 1}
	elseif color == 'IVORY' then
		return {255/255,255/255,240/255,alpha or 1}
	elseif color == 'AZURE' then
		return {240/255,255/255,255/255,alpha or 1}
	elseif color == 'SNOW' then
		return {255/255,250/255,250/255,alpha or 1}
--------------------------------------------------------------
	elseif color == 'DIM GRAY' or color == 'DIM GREY' then
		return {105/255,105/255,105/255,alpha or 1}
	elseif color == 'GRAY' or color == 'GREY' then
		return {128/255,128/255,128/255,alpha or 1}
	elseif color == 'DARK GRAY' or color == 'DARK GREY' then
		return {169/255,169/255,169/255,alpha or 1}
	elseif color == 'SILVER' then
		return {192/255,192/255,192/255,alpha or 1}
	elseif color == 'LIGHT GRAY' or color == 'LIGHT GREY' then
		return {211/255,211/255,211/255,alpha or 1}
	elseif color == 'GAINSBORO' then
		return {220/255,220/255,220/255,alpha or 1}
	elseif color == 'WHITE SMOKE' then
		return {245/255,245/255,245/255,alpha or 1}
--------------------------------------------------------------
-----------------------Custom---------------------------------
--------------------------------------------------------------
	elseif color == 'AND DM GRAY' then
		return {66/255,66/255,66/255,alpha or 1}
	elseif color == 'AND DM PALE BLACK' then
		return {33/255,33/255,33/255,alpha or 1}
	elseif color == 'AND DM FADED BLACK' then
		return {100/255,100/255,100/255,alpha or 1}
	elseif color == 'AND DM CYAN' then
		return {128/255,203/255,196/255,alpha or 1}
--------------------------------------------------------------
	elseif color == 'CUSTOM CYAN' then
		return {0/255,155/255,148/255,alpha or 1}
	end
end
