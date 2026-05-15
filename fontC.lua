local minFontSize = 6
local maxFontSize = 16

local screenX, screenY = guiGetScreenSize()

local createdFonts = {}
local availableFonts = {
	["Ubuntu"] = "fonts/Ubuntu-Regular.ttf",
	["UbuntuB"] = "fonts/Ubuntu-Bold.ttf",
	["UbuntuM"] = "fonts/Ubuntu-Medium.ttf",
	["UbuntuL"] = "fonts/Ubuntu-Light.ttf",
	["Pricedown"] = "fonts/Pricedown.otf",
	["BebasNeueBold"] = "fonts/BebasNeueBold.otf",
	["BebasNeueLight"] = "fonts/BebasNeueLight.otf",
	["BebasNeueRegular"] = "fonts/BebasNeueRegular.otf",
}

function getFont(fontName, fontSize)
	local fontElement = false

	if fontName and fontSize then
		local subText = fontName .. fontSize
		local fontValue = createdFonts[subText]

		if fontValue then
			fontElement = fontValue
		end
	end

	if not fontElement then
		local fontValue = availableFonts[fontName]

		if fontValue then
			local subText = fontName .. fontSize

			if subText then
				fontElement = dxCreateFont(fontValue, fontSize)

				if fontElement then
					createdFonts[subText] = fontElement
				end
			end
		end
	end

	return fontElement
end