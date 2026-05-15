activeInput = false
inputValues = {}
inputMaxLengths = {}
inputChangeEvents = {}
inputNumberOnly = {}
inputPassword = {}
inputTypes = {}

function render.input(guiElement, type, x, y, w, h, parent, color, hoverColor, font, placeHolder, padding, iconColor, icon, textColor)
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
        dxDrawImage(x, y, w, h, getGradient(unpack(isGradient)), 0, 0, 0, tocolor(255, 255, 255, 255 * guiAlphas[guiElement]))
    else
        dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 255 * guiAlphas[guiElement]))
    end

    dxDrawRectangle(x, y, w, 2, tocolor(255, 255, 255, 20 * guiAlphas[guiElement])) -- fent
    dxDrawRectangle(x, y + h - 2, w, 2, tocolor(255, 255, 255, 20 * guiAlphas[guiElement])) -- lent
    dxDrawRectangle(x, y + 2, 2, h - 4, tocolor(255, 255, 255, 20 * guiAlphas[guiElement])) -- bal
    dxDrawRectangle(x + w - 2, y + 2, 2, h - 4, tocolor(255, 255, 255, 20 * guiAlphas[guiElement])) -- jobb

    if icon then
        dxDrawRectangle(x + h, y + 2, 2, h - 4, tocolor(255, 255, 255, 20 * guiAlphas[guiElement]))
        dxDrawImage(x + 2, y + 2, h - 4, h - 4, icon, 0, 0, 0, tocolor(255, 255, 255, 20 * guiAlphas[guiElement]))
        x = x + h
        w = w - h
    end

    if hoverColor then
        local r, g, b
        local colorDetails = split(hoverColor, ":")
        if colorDetails[1] == "gradient" then
            isGradient = {}
            
            local gradientDetails = split(colorDetails[2], "-")
            for i = 1, 9 do
                isGradient[i] = tonumber(gradientDetails[i])
            end
            r, g, b = 255, 255, 255
        else
            r, g, b = getColor(colorDetails[2])
        end
    
        local hr, hg, hb, ha = 255, 255, 255, 255
        if guiHovers[guiElement] or activeInput == guiElement then
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

    local fontH = dxGetFontHeight(1, font)
    
    local inputValue = inputValues[guiElement]
    if inputPassword[guiElement] then
        inputValue = string.gsub(inputValue, ".", "*")
    end
    local textW = dxGetTextWidth(inputValue, 1, font)

    if textW > w - 10 then
        if utfLen(inputValues[guiElement]) > 0 then
            dxDrawText(inputValue, x + 5, y, x + w - 5, y + h, tocolor(233, 233, 233, 255 * guiAlphas[guiElement]), 1, font, "right", "center", true)
        else
            if isGradient then
                dxDrawText(placeHolder, x + 5, y, x + w - 5, y + h, tocolor(50, 50, 50, 255 * guiAlphas[guiElement]), 1, font, "right", "center", true)
            else
                dxDrawText(placeHolder, x + 5, y, x + w - 5, y + h, tocolor(r + 50, g + 50, b + 50, 255 * guiAlphas[guiElement]), 1, font, "right", "center", true)
            end
        end

        if activeInput == guiElement then
            local cursorAlpha = 1
            local elapsedTime = getTickCount()%1500
            if elapsedTime <= 750 then
                cursorAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime/750, "Linear")
            else
                cursorAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, (elapsedTime-750)/750, "Linear")
            end

            dxDrawRectangle(x + w - 5, y + h/2 - fontH/2, 1, fontH, tocolor(233, 233, 233, 200 * cursorAlpha))
        end
    else
        if utfLen(inputValues[guiElement]) > 0 then
            dxDrawText(inputValue, x + 5, y, x + w, y + h, tocolor(233, 233, 233, 255 * guiAlphas[guiElement]), 1, font, "left", "center")
        else
            if isGradient then
                dxDrawText(placeHolder, x + 5, y, x + w, y + h, tocolor(50, 50, 50, 255 * guiAlphas[guiElement]), 1, font, "left", "center")
            else
                dxDrawText(placeHolder, x + 5, y, x + w, y + h, tocolor(r + 50, g + 50, b + 50, 255 * guiAlphas[guiElement]), 1, font, "left", "center")
            end
        end

        if activeInput == guiElement then
            local cursorAlpha = 1
            local elapsedTime = getTickCount()%1500
            if elapsedTime <= 750 then
                cursorAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime/750, "Linear")
            else
                cursorAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, (elapsedTime-750)/750, "Linear")
            end

            if utfLen(inputValues[guiElement]) <= 0 then
                textW = -2
            end
            dxDrawRectangle(x + 7 + textW, y + h/2 - fontH/2, 1, fontH, tocolor(233, 233, 233, 200 * cursorAlpha))
        end
    end
end

function setInputPlaceholder(guiElement, text)
    guiElements[guiElement][11] = text
end

function setInputValue(guiElement, value)
    inputValues[guiElement] = value
end

function setInputFont(guiElement, setFont)
    if not fonts[setFont] then
        local size, font = unpack(split(setFont, "/"))
        fonts[setFont] = getFont(font, tonumber(size))
    end
    guiElements[guiElement][10] = fonts[setFont]
end

function setInputIcon(guiElement, icon)
    local iconDetails = split(icon, ":")
    if iconDetails[1] == "fa" then
        local faDetails = split(iconDetails[2], "/")
        icon = getFaIconFilename(faDetails[1], guiElements[guiElement][6] - 4, faDetails[2])
    end
    guiElements[guiElement][14] = icon
end

function setInputMaxLength(guiElement, maxLength)
    inputMaxLengths[guiElement] = maxLength
end

function setInputChangeEvent(guiElement, changeEvent)
    inputChangeEvents[guiElement] = changeEvent
end

function setInputNumberOnly(guiElement, state)
    inputNumberOnly[guiElement] = state
end

function setInputColor(guiElement, color)
    guiElements[guiElement][15] = color
end

function setInputPassword(guiElement, state)
    inputPassword[guiElement] = state
end

function getInputValue(guiElement)
    return inputValues[guiElement]
end

function getActiveInput()
    return activeInput
end

function setActiveInput(guiElement)
    activeInput = guiElement
end

function setInputType(guiElement, type)
    inputTypes[guiElement] = type
end

addEventHandler("onClientCharacter", getRootElement(),
    function(character)
        if activeInput and (not inputMaxLengths[activeInput] or (#inputValues[activeInput] < inputMaxLengths[activeInput])) then
            if inputTypes[activeInput] and not string.find(character, inputTypes[activeInput]) then
                return
            end
            if inputNumberOnly[activeInput] and not tonumber(character) then
                return
            end

            inputValues[activeInput] = inputValues[activeInput] .. character
            if inputChangeEvents[activeInput] then
                triggerEvent(inputChangeEvents[activeInput], getRootElement(), inputValues[activeInput])
            end
        end
    end
)

function subFakeInputText(inputname, repeatTheTimer)
	if utf8.len(inputValues[inputname]) > 0 then
		inputValues[inputname] = utf8.sub(inputValues[inputname], 1, -2)

		if repeatTheTimer then
			repeatTimer = setTimer(subFakeInputText, 50, 1, inputname, repeatTheTimer)
		else
			playSound("files/backspace.mp3")
		end
        if inputChangeEvents[activeInput] then
            triggerEvent(inputChangeEvents[activeInput], getRootElement())
        end
	end
end

addEventHandler("onClientKey", getRootElement(),
    function(key, press)
        if activeInput then
            cancelEvent()
        end
        if press then
            if activeInput and key == "backspace" then
                subFakeInputText(activeInput)

                if getKeyState(key) then
                    repeatStartTimer = setTimer(subFakeInputText, 500, 1, activeInput, true)
                end
            end
        else
            if isTimer(repeatStartTimer) then
                killTimer(repeatStartTimer)
            end
    
            if isTimer(repeatTimer) then
                killTimer(repeatTimer)
            end
        end
    end
)