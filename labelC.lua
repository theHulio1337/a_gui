function render.label(guiElement, type, x, y, w, h, parent, text, font, alignX, alignY, clip, wordBreak, rotation, color, shadow)
    if shadow then
        dxDrawText(string.gsub(text, "#......", ""), x + 1, y + 1, x + w + 1, y + h + 1, tocolor(0, 0, 0), 1, font, alignX, alignY, clip, wordBreak, false, containsHex(text), false, rotation)
    end
    local r, g, b = getColor(color)
    dxDrawText(text, x, y, x + w, y + h, tocolor(r, g, b, 255 * guiAlphas[guiElement]), 1, font, alignX, alignY, clip, wordBreak, false, containsHex(text), false, rotation)
end

function containsHex(inputString)
    local colorCodes = {}
    for code in inputString:gmatch("#([0-9a-fA-F]+)") do
        table.insert(colorCodes, "#" .. code)
    end
    return (#colorCodes > 0)
end

function setLabelText(guiElement, text)
    if text then
        local text = string.gsub(text, "%[color=(.-)%]", function(colorTag)
            local hex = colorSchemes[colorTag]
            if hex then
                return hex.hex
            else
                return "[color=" .. colorTag .. "]"
            end
        end)
    end
    guiElements[guiElement][8] = text
end

function setLabelFont(guiElement, setFont)
    if not fonts[setFont] then
        local size, font = unpack(split(setFont, "/"))
        fonts[setFont] = getFont(font, tonumber(size))
    end
    guiElements[guiElement][9] = fonts[setFont]
end

function setLabelAlignment(guiElement, alignX, alignY)
    guiElements[guiElement][10] = alignX
    guiElements[guiElement][11] = alignY
end

function getLabelTextWidth(guiElement)
    return dxGetTextWidth(guiElements[guiElement][8], 1, guiElements[guiElement][9])
end

function getLabelFontHeight(guiElement)
    return dxGetFontHeight(1, guiElements[guiElement][9])
end

function setLabelClip(guiElement, state)
    guiElements[guiElement][12] = state
end

function setLabelWordBreak(guiElement, state)
    guiElements[guiElement][13] = state
end

function setLabelRotation(guiElement, rotation)
    guiElements[guiElement][14] = rotation
end

function setLabelColor(guiElement, color)
    guiElements[guiElement][15] = color
end

function setLabelShadow(guiElement, state)
    guiElements[guiElement][16] = state
end