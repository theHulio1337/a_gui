local alerts = {}
local alertTypes = {
    ["error"] = {
        rgb = {215, 89, 89},
        rgb2 = {180, 70, 70},
        iconName = "times-circle"
    }
}

local alertId = 0
function createAlert(type, msg)
    if not alertTypes[type].icon then
        alertTypes[type].icon = getFaIconFilename(alertTypes[type].iconName, 40)
    end

    alertId = alertId + 1
    table.insert(alerts, {
        type = type,
        msg = msg,
        id = alertId, 
        tick = getTickCount()
    })
end
addEvent("createAlert", true)
addEventHandler("createAlert", resourceRoot, createAlert)

addCommandHandler("createalert",
    function(_, type, msg)
        createAlert(type, msg)
    end
)

addEventHandler("onClientRender", getRootElement(),
    function()
        for i = 1, #alerts do
            local alert = alerts[i]

            local tw = dxGetTextWidth(alert.msg, 1, defaultFont2)
            local h = 40
            local w = tw + h + 10
            local x = screenX/2 - w/2
            local y = 20 + (i-1) * (h + 10)
            local a = 1
            
            local elapsedTime = getTickCount() - alert.tick
            if elapsedTime < 200 then
                if not colorSwitch["alert:" .. alertId] then
                    colorSwitch["alert:" .. alertId] = {y, 0, 0, 0}
                end
                y, a = processColorSwitchEffect("alert:" .. alert.id, y, 1, 0, 0, 200, "Linear")
            elseif elapsedTime > 9800 then
                y, a = processColorSwitchEffect("alert:" .. alert.id, y, 0, 0, 0, 200, "Linear")
            else
                y, a = processColorSwitchEffect("alert:" .. alert.id, y, 1, 0, 0, 200, "Linear")
            end
            
            local r, g, b = unpack(alertTypes[alert.type].rgb)
            dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 255 * a))
            local r2, g2, b2 = unpack(alertTypes[alert.type].rgb2)
            dxDrawRectangle(x, y, h, h, tocolor(r2, g2, b2, 255 * a))
            dxDrawImage(x, y, h, h, alertTypes[alert.type].icon)

            dxDrawText(alert.msg, x + h, y, x + w, y + h, tocolor(233, 233, 233, 255 * a), 1, defaultFont2, "center", "center")

            if elapsedTime >= 10000 then
                table.remove(alerts, i)
            end
        end
    end
)