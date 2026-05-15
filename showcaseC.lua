-- showcaseC.lua – fix ablakméret (nincs átméretezés), minden elem stabil
if not split then
    function split(inputstr, sep)
        if sep == nil then sep = "%s" end
        local t = {}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end
        return t
    end
end

local gui = exports.a_gui
local screenX, screenY = guiGetScreenSize()

local mainWindow = nil
local groupElements = {}
local actions = {}
local currentGroup = "basic"

addEvent("showcase:inputChange", true)
addEvent("showcase:sliderChange", true)
addEvent("showcase:click", true)

addEventHandler("showcase:click", root, function(el)
    if actions[el] then actions[el]() end
end)

function showGroup(groupName)
    for name, elements in pairs(groupElements) do
        local visible = (name == groupName)
        for _, el in ipairs(elements) do
            if isElement(el) then
                gui:setGuiAlpha(el, visible and 255 or 0)
            end
        end
    end
    currentGroup = groupName
end

function createShowcase()
    if isElement(mainWindow) then return end
    local w, h = 800, 600
    local x, y = (screenX-w)/2, (screenY-h)/2

    mainWindow = gui:createGuiElement("rectangle", x, y, w, h, nil)
    gui:setGuiBackground(mainWindow, "solid", "grey2")
    gui:setGuiMoveable(mainWindow, {0, 0, w, 30})

    -- Címsáv
    local titleBar = gui:createGuiElement("rectangle", 0, 0, w, 30, mainWindow)
    gui:setGuiBackground(titleBar, "solid", "grey3")
    local titleLabel = gui:createGuiElement("label", 10, 5, w-80, 20, mainWindow)
    gui:setLabelText(titleLabel, "GUI Rendszer Bemutató")
    gui:setLabelFont(titleLabel, "18/UbuntuB")
    gui:setLabelColor(titleLabel, "#ffffff")
    gui:setLabelAlignment(titleLabel, "left", "center")

    -- Bezáró gomb
    local closeBtn = gui:createGuiElement("button", w-30, 5, 25, 20, mainWindow)
    gui:setGuiBackground(closeBtn, "solid", "red")
    gui:setGuiHover(closeBtn, "solid", "red2")
    gui:setButtonText(closeBtn, "X")
    gui:setButtonFont(closeBtn, "14/UbuntuB")
    gui:setButtonTextColor(closeBtn, "#ffffff")
    gui:setClickEvent(closeBtn, "showcase:click")
    actions[closeBtn] = function()
        if isElement(mainWindow) then
            destroyElement(mainWindow)
            mainWindow = nil
            groupElements = {}
            actions = {}
            showCursor(false)
        end
    end

    -- Menügombok
    local groupsDef = {
        {"Alapok", "basic"},
        {"Beviteli", "input"},
        {"Animációk", "anim"},
        {"Egyéb", "misc"}
    }
    for i, def in ipairs(groupsDef) do
        local btn = gui:createGuiElement("button", 10+(i-1)*105, 35, 100, 30, mainWindow)
        gui:setGuiBackground(btn, "solid", "primary")
        gui:setGuiHover(btn, "solid", "accent")
        gui:setButtonText(btn, def[1])
        gui:setButtonFont(btn, "14/Ubuntu")
        gui:setButtonTextColor(btn, "#ffffff")
        gui:setClickEvent(btn, "showcase:click")
        actions[btn] = function() showGroup(def[2]) end
    end

    -- Tartalom terület (fix méret)
    local cx, cy, cw, ch = 10, 75, w-20, h-85

    -------------------------
    -- 1. ALAPOK CSOPORT
    -------------------------
    local basicGroup = gui:createGuiElement("rectangle", cx, cy, cw, ch, mainWindow)
    gui:setGuiBackground(basicGroup, "solid", "grey")
    groupElements.basic = {basicGroup}

    local demoLabel = gui:createGuiElement("label", 20, 20, 300, 30, basicGroup)
    gui:setLabelText(demoLabel, "Ez egy címke szövege")
    gui:setLabelFont(demoLabel, "16/UbuntuB")
    gui:setLabelColor(demoLabel, "#43c60f")
    gui:setLabelShadow(demoLabel, false)
    table.insert(groupElements.basic, demoLabel)

    local changeBtn = gui:createGuiElement("button", 20, 60, 150, 30, basicGroup)
    gui:setGuiBackground(changeBtn, "solid", "primary")
    gui:setGuiHover(changeBtn, "solid", "accent")
    gui:setButtonText(changeBtn, "Módosít")
    gui:setButtonFont(changeBtn, "14/Ubuntu")
    gui:setButtonTextColor(changeBtn, "#ffffff")
    gui:setClickEvent(changeBtn, "showcase:click")
    actions[changeBtn] = function()
        gui:setLabelText(demoLabel, "Új szöveg: " .. math.random(100,999))
    end
    table.insert(groupElements.basic, changeBtn)

    local imageEl = gui:createGuiElement("image", 200, 60, 64, 64, basicGroup)
    gui:setImageFile(imageEl, getFaIconFilename("cog", 64, "solid"))
    gui:setImageColor(imageEl, "#43c60f")
    gui:setGuiTooltip(imageEl, "Beállítások ikon")
    table.insert(groupElements.basic, imageEl)

    local checkboxEl = gui:createGuiElement("checkbox", 20, 110, 200, 30, basicGroup)
    gui:setCheckboxText(checkboxEl, "Engedélyezés")
    gui:setCheckboxFont(checkboxEl, "14/Ubuntu")
    gui:setCheckboxIcon(checkboxEl, "fa:check-circle/solid")
    gui:setClickEvent(checkboxEl, "showcase:click")
    actions[checkboxEl] = function()
        if gui:isCheckboxChecked(checkboxEl) then
            createAlert("success", "Checkbox bejelölve!")
        else
            createAlert("warning", "Checkbox kijelölve!")
        end
    end
    table.insert(groupElements.basic, checkboxEl)

    -------------------------
    -- 2. BEVITELI CSOPORT
    -------------------------
    local inputGroup = gui:createGuiElement("rectangle", cx, cy, cw, ch, mainWindow)
    gui:setGuiBackground(inputGroup, "solid", "grey")
    groupElements.input = {inputGroup}

    local inputEl = gui:createGuiElement("input", 20, 20, 250, 35, inputGroup)
    gui:setInputPlaceholder(inputEl, "Írj be valamit...")
    gui:setInputFont(inputEl, "14/Ubuntu")
    gui:setInputIcon(inputEl, "fa:user/solid")
    gui:setInputChangeEvent(inputEl, "showcase:inputChange")
    gui:setInputMaxLength(inputEl, 30)
    table.insert(groupElements.input, inputEl)

    local inputValueLabel = gui:createGuiElement("label", 20, 70, 300, 25, inputGroup)
    gui:setLabelText(inputValueLabel, "Érték: ")
    gui:setLabelFont(inputValueLabel, "14/Ubuntu")
    gui:setLabelColor(inputValueLabel, "#ffffff")
    table.insert(groupElements.input, inputValueLabel)

    local sliderLabel = gui:createGuiElement("label", 20, 110, 200, 25, inputGroup)
    gui:setLabelText(sliderLabel, "Hangerő: 0%")
    gui:setLabelFont(sliderLabel, "14/Ubuntu")
    gui:setLabelColor(sliderLabel, "#ffffff")
    table.insert(groupElements.input, sliderLabel)

    local sliderEl = gui:createGuiElement("slider", 20, 140, 300, 10, inputGroup)
    gui:setGuiBackground(sliderEl, "solid", "grey3")
    gui:setSliderColor(sliderEl, "primary")
    gui:setSliderChangeEvent(sliderEl, "showcase:sliderChange")
    gui:setSliderValue(sliderEl, 0.5)
    table.insert(groupElements.input, sliderEl)

    addEventHandler("showcase:inputChange", root, function(el)
        if el == inputEl then
            local val = gui:getInputValue(inputEl)
            gui:setLabelText(inputValueLabel, "Érték: " .. val)
        end
    end)

    addEventHandler("showcase:sliderChange", root, function(el)
        if el == sliderEl then
            local percent = math.floor(gui:getSliderValue(sliderEl) * 100)
            gui:setLabelText(sliderLabel, "Hangerő: " .. percent .. "%")
        end
    end)

    -------------------------
    -- 3. ANIMÁCIÓK CSOPORT
    -------------------------
    local animGroup = gui:createGuiElement("rectangle", cx, cy, cw, ch, mainWindow)
    gui:setGuiBackground(animGroup, "solid", "grey")
    groupElements.anim = {animGroup}

    local movingBox = gui:createGuiElement("rectangle", 50, 50, 100, 100, animGroup)
    gui:setGuiBackground(movingBox, "solid", "primary")
    table.insert(groupElements.anim, movingBox)

    local animBoxRef = movingBox

    local animBtn = gui:createGuiElement("button", 20, 60, 150, 30, animGroup)
    gui:setGuiBackground(animBtn, "solid", "primary")
    gui:setButtonText(animBtn, "Mozgás")
    gui:setClickEvent(animBtn, "showcase:click")
    actions[animBtn] = function()
        local x, y = gui:getGuiPosition(animBoxRef)
        gui:setGuiPositionAnimated(animBoxRef, x+200, y, 800, "OutBounce")
    end
    table.insert(groupElements.anim, animBtn)

    local sizeAnimBtn = gui:createGuiElement("button", 180, 60, 150, 30, animGroup)
    gui:setGuiBackground(sizeAnimBtn, "solid", "primary2")
    gui:setButtonText(sizeAnimBtn, "Méretezés")
    gui:setClickEvent(sizeAnimBtn, "showcase:click")
    actions[sizeAnimBtn] = function()
        local w, h = gui:getGuiSize(animBoxRef)
        gui:setGuiSizeAnimated(animBoxRef, w+50, h+50, 500, "Linear")
    end
    table.insert(groupElements.anim, sizeAnimBtn)

    local alphaAnimBtn = gui:createGuiElement("button", 340, 60, 150, 30, animGroup)
    gui:setGuiBackground(alphaAnimBtn, "solid", "accent")
    gui:setButtonText(alphaAnimBtn, "Áttűnés")
    gui:setClickEvent(alphaAnimBtn, "showcase:click")
    actions[alphaAnimBtn] = function()
        gui:setGuiAlphaAnimated(animBoxRef, 0, 1000, "Linear")
        setTimer(function()
            if isElement(animBoxRef) then gui:setGuiAlphaAnimated(animBoxRef, 255, 1000, "Linear") end
        end, 1100, 1)
    end
    table.insert(groupElements.anim, alphaAnimBtn)

    local resetAnimBtn = gui:createGuiElement("button", 500, 60, 120, 30, animGroup) -- szélesség növelve
    gui:setGuiBackground(resetAnimBtn, "solid", "red")
    gui:setButtonText(resetAnimBtn, "Reset")
    gui:setClickEvent(resetAnimBtn, "showcase:click")
    actions[resetAnimBtn] = function()
        gui:setGuiPosition(animBoxRef, 50, 50)
        gui:setGuiSize(animBoxRef, 100, 100)
        gui:setGuiAlpha(animBoxRef, 255)
    end
    table.insert(groupElements.anim, resetAnimBtn)

    -------------------------
    -- 4. EGYÉB CSOPORT
    -------------------------
    local miscGroup = gui:createGuiElement("rectangle", cx, cy, cw, ch, mainWindow)
    gui:setGuiBackground(miscGroup, "solid", "grey")
    groupElements.misc = {miscGroup}

    local logoEl = gui:createGuiElement("logo", 20, 20, 128, 128, miscGroup)
    table.insert(groupElements.misc, logoEl)

    local moveablePanel = gui:createGuiElement("rectangle", 200, 150, 200, 150, miscGroup)
    gui:setGuiBackground(moveablePanel, "solid", "grey3")
    gui:setGuiMoveable(moveablePanel, {0, 0, 200, 30})
    gui:setGuiTooltip(moveablePanel, "Húzható panel (fogd meg a címét)")
    table.insert(groupElements.misc, moveablePanel)

    local moveTitle = gui:createGuiElement("label", 0, 0, 200, 30, moveablePanel)
    gui:setGuiBackground(moveTitle, "solid", "primary")
    gui:setLabelText(moveTitle, "Húzz ide")
    gui:setLabelAlignment(moveTitle, "center", "center")
    gui:setLabelColor(moveTitle, "#ffffff")
    table.insert(groupElements.misc, moveTitle)

    local moveContent = gui:createGuiElement("label", 10, 40, 180, 100, moveablePanel)
    gui:setLabelText(moveContent, "Ezt a panelt az egérrel mozgathatod,\nha a felső sávon fogod meg.")
    gui:setLabelFont(moveContent, "12/Ubuntu")
    gui:setLabelColor(moveContent, "#dddddd")
    table.insert(groupElements.misc, moveContent)

    local alertBtn = gui:createGuiElement("button", 20, 170, 150, 30, miscGroup)
    gui:setGuiBackground(alertBtn, "solid", "red")
    gui:setButtonText(alertBtn, "Alert (error)")
    gui:setClickEvent(alertBtn, "showcase:click")
    actions[alertBtn] = function()
        createAlert("error", "Ez egy hibaüzenet!")
    end
    table.insert(groupElements.misc, alertBtn)

    local successAlertBtn = gui:createGuiElement("button", 180, 170, 150, 30, miscGroup)
    gui:setGuiBackground(successAlertBtn, "solid", "green")
    gui:setButtonText(successAlertBtn, "Alert (success)")
    gui:setClickEvent(successAlertBtn, "showcase:click")
    actions[successAlertBtn] = function()
        createAlert("success", "Sikeres művelet!")
    end
    table.insert(groupElements.misc, successAlertBtn)

    local tooltipDemo = gui:createGuiElement("rectangle", 350, 20, 100, 50, miscGroup)
    gui:setGuiBackground(tooltipDemo, "solid", "primary")
    gui:setGuiTooltip(tooltipDemo, "Ez egy tooltip! Érdekes infó.")
    table.insert(groupElements.misc, tooltipDemo)

    -- NINCS ÁTMÉRETEZŐ FOGANTYÚ!
    showGroup("basic")
end

addCommandHandler("showcase", function()
    if isElement(mainWindow) then
        destroyElement(mainWindow)
        mainWindow = nil
        groupElements = {}
        actions = {}
        showCursor(false)
    else
        createShowcase()
        showCursor(true)
    end
end)

-- Alert típusok kiegészítése
addEventHandler("onClientResourceStart", resourceRoot, function()
    if not alertTypes then alertTypes = {} end
    if not alertTypes.success then
        alertTypes.success = {rgb={67,198,15}, rgb2={50,150,10}, iconName="check-circle"}
        alertTypes.warning = {rgb={255,193,7}, rgb2={200,150,0}, iconName="exclamation-triangle"}
    end
end)