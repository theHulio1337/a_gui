function render.button(guiElement, type, x, y, w, h, parent, color, hoverColor, font, textColor, text, padding, alignX, alignY, iconColor, icon)
    local r, g, b = getColor(color)
    local isGradient = false
    
    local colorDetails = split(color, ":")
    if colorDetails[1] == "gradient" then
        isGradient = {}
        
        local gradientDetails = split(colorDetails[2], "-")
        for i = 1, 9 do
            isGradient[i] = tonumber(gradientDetails[i])
        end
        r, g, b = 255, 255, 255
    end

    if isGradient then
        dxDrawImage(x, y, w, h, getGradient(unpack(isGradient)))
    else
        dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 255 * guiAlphas[guiElement]))
    end

    if hoverColor then
        local colorDetails = split(hoverColor, ":")

        local r, g, b = getColor(hoverColor)
        if colorDetails[1] == "gradient" then
            isGradient = {}
            
            local gradientDetails = split(colorDetails[2], "-")
            for i = 1, 9 do
                isGradient[i] = tonumber(gradientDetails[i])
            end
            r, g, b = 255, 255, 255
        end
        
        local hr, hg, hb, ha = 255, 255, 255, 255
        if guiHovers[guiElement] and not getKeyState("mouse1") then
            if isGradient then
                hr, hg, hb, ha = processColorSwitchEffect(guiElement, 255, 255, 255, 255, 200, "Linear")
            else
                hr, hg, hb, ha = processColorSwitchEffect(guiElement, r, g, b, 255, 200, "Linear")
            end
        else
            if isGradient then
                hr, hg, hb, ha = processColorSwitchEffect(guiElement, 255, 255, 255, 0, 200, "Linear")
            else
                hr, hg, hb, ha = processColorSwitchEffect(guiElement, r, g, b, 0, 200, "Linear")
            end
        end

        if isGradient then
            dxDrawImage(x, y, w, h, getGradient(unpack(isGradient)), 0, 0, 0, tocolor(hr, hg, hb, ha * guiAlphas[guiElement]))
        else
            dxDrawRectangle(x, y, w, h, tocolor(hr, hg, hb, ha * guiAlphas[guiElement]))
        end
    end

    local r, g, b = getColor(textColor)

    local x2, y2 = x, y    
    if icon then
        local fontH = dxGetFontHeight(1, guiElements[guiElement][10] or defaultFont)
        local textW = dxGetTextWidth(text, 1, guiElements[guiElement][10] or defaultFont)
        local size = math.floor(fontH) * 1.2

        local x, y = x2, y2
        if alignX == "left" then
            x = x + padding[1]
        elseif alignX == "right" then
            x = x + padding[1] + w - textW - size - 2
        elseif alignX == "center" then
            x = x + padding[1] + w/2 - textW/2 - size/2 - 2
        end
        
        if alignY == "bottom" then
            y = y + padding[2] + h - size
        elseif alignY == "top" then
            y = y + padding[2]
        elseif alignY == "center" then
            y = y + padding[2] + h/2 - size/2
        end
        if text ~= "" then
            dxDrawImage(x, y, size, size, icon)
        else
            dxDrawImage(x2, y2, size, size, icon)
        end

        local x, y = x2, y2
        if alignX == "left" then
            x = x + padding[1] + size + 2
        elseif alignX == "right" then
            x = x + padding[1]
        elseif alignX == "center" then
            x = x + size
        end
        dxDrawText(text, x + padding[1], y + padding[2], x2 + padding[1] + w, y2 + padding[2] + h, tocolor(r, g, b, 255 * guiAlphas[guiElement]), 1, font, alignX, alignY, true, false, false, false)
    else
        dxDrawText(text, x + padding[1], y + padding[2], x2 + padding[1] + w, y2 + padding[2] + h, tocolor(r, g, b, 255 * guiAlphas[guiElement]), 1, font, alignX, alignY, true, false, false, false)
    end

    if (r + g + b)/765 > 0.5 then
        dxDrawRectangle(x, y, w, 2, tocolor(0, 0, 0, 50 * guiAlphas[guiElement])) -- fent
        dxDrawRectangle(x, y + h - 2, w, 2, tocolor(0, 0, 0, 50 * guiAlphas[guiElement])) -- lent
        dxDrawRectangle(x, y + 2, 2, h - 4, tocolor(0, 0, 0, 50 * guiAlphas[guiElement])) -- bal
        dxDrawRectangle(x + w - 2, y + 2, 2, h - 4, tocolor(0, 0, 0, 50 * guiAlphas[guiElement])) -- jobb
    else
        dxDrawRectangle(x, y, w, 2, tocolor(255, 255, 255, 50 * guiAlphas[guiElement])) -- fent
        dxDrawRectangle(x, y + h - 2, w, 2, tocolor(255, 255, 255, 50 * guiAlphas[guiElement])) -- lent
        dxDrawRectangle(x, y + 2, 2, h - 4, tocolor(255, 255, 255, 50 * guiAlphas[guiElement])) -- bal
        dxDrawRectangle(x + w - 2, y + 2, 2, h - 4, tocolor(255, 255, 255, 50 * guiAlphas[guiElement])) -- jobb
    end
end

function setButtonFont(guiElement, setFont)
    if not fonts[setFont] then
        local size, font = unpack(split(setFont, "/"))
        fonts[setFont] = getFont(font, tonumber(size))
    end
    guiElements[guiElement][10] = fonts[setFont]
end

function setButtonTextColor(guiElement, color)
    guiElements[guiElement][11] = color
end

function setButtonText(guiElement, text)
    local text = string.gsub(text, "%[color=(.-)%]", function(colorTag)
        local hex = colorSchemes[colorTag]
        if hex then
            return hex.hex
        else
            return "[color=" .. colorTag .. "]"
        end
    end)
    guiElements[guiElement][12] = text
end

function setButtonTextPadding(guiElement, x, y)
    guiElements[guiElement][13] = {x, y}
end

function setButtonTextAlign(guiElement, x, y)
    guiElements[guiElement][14] = x
    guiElements[guiElement][15] = y
end

function setButtonIconColor(guiElement, color)
    guiElements[guiElement][16] = color
end

function setButtonIcon(guiElement, icon)
    local iconDetails = split(icon, ":")
    if iconDetails[1] == "fa" then
        local faDetails = split(iconDetails[2], "/")
        icon = getFaIconFilename(faDetails[1], math.floor(dxGetFontHeight(1, guiElements[guiElement][10] or defaultFont) * 1.2), faDetails[2])
    end
    guiElements[guiElement][17] = icon
end