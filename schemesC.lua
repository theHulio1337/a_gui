colorSchemes = {
    grey = {
        rgb = {22, 22, 30}
    },
    grey2 = {
        rgb = {30, 30, 40}
    },
    grey3 = {
        rgb = {38, 38, 52}
    },
    grey4 = {
        rgb = {48, 48, 66}
    },
    primary = {
        rgb = {129, 53, 254}
    },
    primary2 = {
        rgb = {149, 92, 255}
    },
    accent = {
        rgb = {194, 170, 255}
    },
    accent2 = {
        rgb = {166, 140, 235}
    },
    red = {
        rgb = {220, 110, 130}
    },
    red2 = {
        rgb = {240, 140, 160}
    },
    green = {
        rgb = {120, 210, 170}
    },
}

function getColorSchemes()
    return colorSchemes
end

function RGBToHex(red, green, blue)
    return string.format("#%.2X%.2X%.2X", red, green, blue)
end

for k, v in pairs(colorSchemes) do
    colorSchemes[k].hex = RGBToHex(unpack(colorSchemes[k].rgb))
end

function getColor(c)
    local r, g, b = 0, 0, 0

    if type(c) == "table" then
        r, g, b = unpack(c)
    else
        local type, color = unpack(split(c, ":"))
        if type == "solid" then
            if colorSchemes[color] then
                r, g, b = unpack(colorSchemes[color].rgb)
            elseif utfSub(color, 0, 1) == "#" then
                r, g, b = HEXtoRGB(color)
            end
        elseif type == "gradient" then
            if colorSchemes[color] then
                r, g, b = unpack(colorSchemes[color].rgb)
            elseif utfSub(color, 0, 1) == "#" then
                r, g, b = HEXtoRGB(color)
            end
        else
            if colorSchemes[c] then
                r, g, b = unpack(colorSchemes[c].rgb)
            elseif utfSub(c, 0, 1) == "#" then
                r, g, b = HEXtoRGB(c)
            end
        end
    end

    return r, g, b
end

function HEXtoRGB(hexArg)
	hexArg = hexArg:gsub('#','')

	if(string.len(hexArg) == 3) then
		return tonumber('0x'..hexArg:sub(1,1)) * 17, tonumber('0x'..hexArg:sub(2,2)) * 17, tonumber('0x'..hexArg:sub(3,3)) * 17
	elseif(string.len(hexArg) == 6) then
		return tonumber('0x'..hexArg:sub(1,2)), tonumber('0x'..hexArg:sub(3,4)), tonumber('0x'..hexArg:sub(5,6))
	else
		return 0, 0, 0
	end
end