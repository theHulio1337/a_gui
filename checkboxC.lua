checkboxValues = {}

function render.checkbox(guiElement, type, x, y, w, h, parent, color, hoverColor, font, placeHolder, iconColor, icon, textColor)
    local a = guiAlphas[guiElement]
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
        dxDrawImage(x, y, h, h, getGradient(unpack(isGradient)), 0, 0, 0, tocolor(255, 255, 255, 255 * a))
    else
        dxDrawRectangle(x, y, h, h, tocolor(r, g, b, 255 * guiAlphas[guiElement]))
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
            dxDrawImage(x, y, h, h, getGradient(unpack(isGradient)), 0, 0, 0, tocolor(hr, hg, hb, ha * guiAlphas[guiElement]))
        else
            dxDrawRectangle(x, y, h, h, tocolor(hr, hg, hb, ha * guiAlphas[guiElement]))
        end
    end

    if (r + g + b)/765 > 0.5 then
        dxDrawRectangle(x, y, h, 2, tocolor(0, 0, 0, 10 * guiAlphas[guiElement])) -- fent
        dxDrawRectangle(x, y + h - 2, h, 2, tocolor(0, 0, 0, 10 * guiAlphas[guiElement])) -- lent
        dxDrawRectangle(x, y + 2, 2, h - 4, tocolor(0, 0, 0, 10 * guiAlphas[guiElement])) -- bal
        dxDrawRectangle(x + h - 2, y + 2, 2, h - 4, tocolor(0, 0, 0, 10 * guiAlphas[guiElement])) -- jobb
    else
        dxDrawRectangle(x, y, h, 2, tocolor(255, 255, 255, 10 * guiAlphas[guiElement])) -- fent
        dxDrawRectangle(x, y + h - 2, h, 2, tocolor(255, 255, 255, 10 * guiAlphas[guiElement])) -- lent
        dxDrawRectangle(x, y + 2, 2, h - 4, tocolor(255, 255, 255, 10 * guiAlphas[guiElement])) -- bal
        dxDrawRectangle(x + h - 2, y + 2, 2, h - 4, tocolor(255, 255, 255, 10 * guiAlphas[guiElement])) -- jobb
    end

    if checkboxValues[guiElement] then
        local r, g, b = getColor(iconColor)
        dxDrawImage(x + 2, y + 2, h - 4, h - 4, icon, 0, 0, 0, tocolor(r, g, b, 255 * a))
    end

    dxDrawText(placeHolder, x + h + 5, y, x + w, y + h, tocolor(233, 233, 233, 255 * a), 1, font, "left", "center", true)
end

function isCheckboxChecked(guiElement)
    return checkboxValues[guiElement]
end

function setCheckboxChecked(guiElement, state)
    checkboxValues[guiElement] = state
end

function setCheckboxIcon(guiElement, icon)
    local iconDetails = split(icon, ":")
    if iconDetails[1] == "fa" then
        local faDetails = split(iconDetails[2], "/")
        icon = getFaIconFilename(faDetails[1], guiElements[guiElement][6] - 4, faDetails[2])
    end
    guiElements[guiElement][13] = icon
end

function setCheckboxIconColor(guiElement, color)
    guiElements[guiElement][12] = color
end

function setCheckboxFont(guiElement, setFont)
    if not fonts[setFont] then
        local size, font = unpack(split(setFont, "/"))
        fonts[setFont] = getFont(font, tonumber(size))
    end
    guiElements[guiElement][10] = fonts[setFont]
end

function setCheckboxText(guiElement, text)
    guiElements[guiElement][11] = text
end