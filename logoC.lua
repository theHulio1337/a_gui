local interpolateStates = {}
local interpolateStart = {}
function render.logo(guiElement, type, x, y, w, h, parent, color, hoverColor)
    local a = guiAlphas[guiElement]
    local path = "files/logos/"
    local s = math.max(w, h)
    if s <= 32 then
        path = path .. "32_"
    elseif s <= 64 then
        path = path .. "64_"
    elseif s <= 128 then
        path = path .. "128_"
    elseif s <= 256 then
        path = path .. "256_"
    elseif s <= 512 then
        path = path .. "512_"
    elseif s <= 1024 then
        path = path .. "1024_"
    elseif s <= 2048 then
        path = path .. "2048_"
    end

    if not interpolateStates[guiElement] then
        interpolateStates[guiElement] = 0
        interpolateStart[guiElement] = getTickCount()
    end
    local elapsedTime = getTickCount() - interpolateStart[guiElement]
    local elapsedTimeCycle = elapsedTime % 15000

    local r, g, b = unpack(colorSchemes.primary.rgb)
    if elapsedTimeCycle <= 5000 then
        r, g, b = interpolateBetween(
            colorSchemes.primary.rgb[1], colorSchemes.primary.rgb[2], colorSchemes.primary.rgb[3],
            colorSchemes.accent.rgb[1], colorSchemes.accent.rgb[2], colorSchemes.accent.rgb[3],
            elapsedTimeCycle/5000, "Linear"
        )
    elseif elapsedTimeCycle > 5000 and elapsedTimeCycle <= 15000 then
        r, g, b = interpolateBetween(
            colorSchemes.accent.rgb[1], colorSchemes.accent.rgb[2], colorSchemes.accent.rgb[3],
            colorSchemes.primary.rgb[1], colorSchemes.primary.rgb[2], colorSchemes.primary.rgb[3],
            (elapsedTimeCycle-5000)/10000, "Linear"
        )
    end

    local alpha = 0
    local x2, y2 = 0, 0
    if elapsedTimeCycle < 200 then
        alpha = interpolateBetween(0, 0, 0, 255, 0, 0, elapsedTimeCycle/200, "Linear")
        x2, y2 = interpolateBetween(-10, -5, 0, 0, 0, 0, elapsedTimeCycle/200, "Linear")
    elseif elapsedTimeCycle > 14500 then
        alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (elapsedTimeCycle-14500)/200, "Linear")
        x2, y2 = interpolateBetween(0, 0, 0, -10, -5, 0, (elapsedTimeCycle-14500)/200, "Linear")
    elseif elapsedTimeCycle >= 200 then
        alpha = 255
    end
    dxDrawImage(x + x2, y + y2, w, h, path .. "a.png", 0, 0, 0, tocolor(r, g, b, a * alpha))

    local r, g, b = unpack(colorSchemes.primary.rgb)
    if elapsedTimeCycle >= 7500 and elapsedTimeCycle <= 12000 then
        r, g, b = interpolateBetween(
            colorSchemes.primary.rgb[1], colorSchemes.primary.rgb[2], colorSchemes.primary.rgb[3],
            colorSchemes.accent.rgb[1], colorSchemes.accent.rgb[2], colorSchemes.accent.rgb[3],
            (elapsedTimeCycle-7500)/4500, "Linear"
        )
    elseif elapsedTimeCycle > 12000 and elapsedTimeCycle <= 15000 then
        r, g, b = interpolateBetween(
            colorSchemes.accent.rgb[1], colorSchemes.accent.rgb[2], colorSchemes.accent.rgb[3],
            colorSchemes.primary.rgb[1], colorSchemes.primary.rgb[2], colorSchemes.primary.rgb[3],
            (elapsedTimeCycle-12000)/3000, "Linear"
        )
    end

    local alpha = 0
    local x2, y2 = 0, 0
    if elapsedTimeCycle > 300 and elapsedTimeCycle < 500 then
        alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (elapsedTimeCycle-300)/200, "Linear")
        x2, y2 = interpolateBetween(10, 5, 0, 0, 0, 0, (elapsedTimeCycle-300)/200, "Linear")
    elseif elapsedTimeCycle > 14500 then
        alpha =  interpolateBetween(255, 0, 0, 0, 0, 0, (elapsedTimeCycle-14500)/200, "Linear")
        x2, y2 = interpolateBetween(0, 0, 0, 10, 5, 0, (elapsedTimeCycle-14500)/200, "Linear")
    elseif elapsedTimeCycle >= 500 then
        alpha = 255
    end
    dxDrawImage(x + x2, y + y2, w, h, path .. "s.png", 0, 0, 0, tocolor(r, g, b, a * alpha))

    local r, g, b = unpack(colorSchemes.primary.rgb)
    if elapsedTimeCycle >= 4000 and elapsedTimeCycle <= 9000 then
        r, g, b = interpolateBetween(
            colorSchemes.primary.rgb[1], colorSchemes.primary.rgb[2], colorSchemes.primary.rgb[3],
            colorSchemes.accent.rgb[1], colorSchemes.accent.rgb[2], colorSchemes.accent.rgb[3],
            (elapsedTimeCycle-4000)/5000, "Linear"
        )
    elseif elapsedTimeCycle > 9000 and elapsedTimeCycle <= 15000 then
        r, g, b = interpolateBetween(
            colorSchemes.accent.rgb[1], colorSchemes.accent.rgb[2], colorSchemes.accent.rgb[3],
            colorSchemes.primary.rgb[1], colorSchemes.primary.rgb[2], colorSchemes.primary.rgb[3],
            (elapsedTimeCycle-9000)/6000, "Linear"
        )
    end

    local alpha = 0
    local x2, y2 = 0, 0
    if elapsedTimeCycle > 600 and elapsedTimeCycle < 800 then
        alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (elapsedTimeCycle-600)/200, "Linear")
        x2, y2 = interpolateBetween(-2, -10, 0, 0, 0, 0, (elapsedTimeCycle-600)/200, "Linear")
    elseif elapsedTimeCycle > 14500 then
        alpha = interpolateBetween(55, 0, 0, 0, 0, 0, (elapsedTimeCycle-14500)/200, "Linear")
        x2, y2 = interpolateBetween(0, 0, 0, -2, -10, 0, (elapsedTimeCycle-14500)/200, "Linear")
    elseif elapsedTimeCycle >= 800 then
        alpha = 255
    end
    dxDrawImage(x + x2, y + y2, w, h, path .. "t.png", 0, 0, 0, tocolor(r, g, b, a * alpha))
end