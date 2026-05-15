sliderValues = {}
sliderEvents = {}
grabSlider = {}

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function render.slider(guiElement, type, x, y, w, h, parent, color, hoverColor, sliderColor)
    local a = guiAlphas[guiElement]
    if color then
        local r, g, b = getColor(color)
        dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 255 * a))
    end

    if not sliderValues[guiElement] then
        sliderValues[guiElement] = 0
    end

    if sliderColor then
        local r, g, b = getColor(sliderColor)
        local rx = reMap(sliderValues[guiElement], 0, 1, x, x + w - h)
        
        local s = h + 4
        DxDrawBorderedRectangle(rx - 2, y - 2, s, s, tocolor(r, g, b, 255 * a), tocolor(0, 0, 0, 255 * a))

        if cx and cx >= rx - 2 and cx <= rx - 2 + s and cy >= y - 2 and cy <= y - 2 + s or grabSlider then
            if getKeyState("mouse1") then
                if not grabSlider then
                    grabSlider = {guiElement, cx - rx - 2, cy - y - 2}
                elseif grabSlider[1] == guiElement then
                    local v = reMap(cx, x, x + w, 0, 1)
                    
                    local trigger = false
                    if sliderEvents[guiElement] and sliderValues[guiElement] ~= math.max(0, math.min(1, v)) then
                        trigger = true
                    end
                    sliderValues[guiElement] = math.max(0, math.min(1, v))
                    if trigger then
                        triggerEvent(sliderEvents[guiElement], getRootElement())
                    end
                end
            else
                if grabSlider then
                    grabSlider = false
                end
            end
        end
    end
end

function DxDrawBorderedRectangle( x, y, width, height, color1, color2, _width, postGUI )
    local _width = _width or 1
    dxDrawRectangle ( x+1, y+1, width-1, height-1, color1, postGUI )
    dxDrawLine ( x, y, x+width, y, color2, _width, postGUI ) -- Top
    dxDrawLine ( x, y, x, y+height, color2, _width, postGUI ) -- Left
    dxDrawLine ( x, y+height, x+width, y+height, color2, _width, postGUI ) -- Bottom
    dxDrawLine ( x+width, y, x+width, y+height, color2, _width, postGUI ) -- Right
end

function setSliderChangeEvent(guiElement, event)
    sliderEvents[guiElement] = event
end

function getSliderValue(guiElement)
    return sliderValues[guiElement]
end

function setSliderValue(guiElement, v)
    sliderValues[guiElement] = v
end

function setSliderColor(guiElement, color)
    guiElements[guiElement][10] = color
end