local shaderRaw = [[bool textureLoad = false;
bool textureRotated = false;
texture sourceTexture;
float rotation = 0;
float4 colorFrom = float4(1,1,1,1);
float4 colorTo = float4(1,1,1,1);
bool colorOverwritten = true;
#define PI 3.1415926535897932384626433832795

SamplerState tSampler{
	Texture = sourceTexture;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

float4 gradientShader(float2 tex:TEXCOORD0,float4 color:COLOR0):COLOR0{
	float4 result = textureLoad?tex2D(tSampler,textureRotated?tex.yx:tex)*color:color;
	float rad = rotation/180*PI;
	float rotSin = sin(rad);
	float rotCos = cos(rad);
	tex -= 0.5;
	float2 kValue = float2(tex.x*rotCos-tex.y*rotSin,tex.x*rotSin+tex.y*rotCos)+0.5;
	float4 colorCalculated = colorFrom+(colorTo-colorFrom)*(kValue.x);
	result.rgb = colorOverwritten?colorCalculated.rgb:(colorCalculated.rgb*result.rgb);
	result.a *= colorCalculated.a;
	return result;
}

technique Gradient{
	pass P0{
		SeparateAlphaBlendEnable = true;
		SrcBlendAlpha = One;
		DestBlendAlpha = InvSrcAlpha;
		PixelShader = compile ps_2_0 gradientShader();
	}
}]]

function createGradient(w, h, r, g, b, r2, g2, b2, rotation)
	rotation = rotation or 0
	local shader = dxCreateShader(shaderRaw)

	dxSetShaderValue(shader,"colorFrom", r/255, g/255, b/255)
	dxSetShaderValue(shader,"colorTo", r2/255, g2/255, b2/255)
	dxSetShaderValue(shader,"rotation", rotation)

    local rt = dxCreateRenderTarget(w, h)
    dxSetRenderTarget(rt, true)
    dxSetBlendMode("modulate_add")
    dxDrawImage(0, 0, w, h, shader)
    dxSetBlendMode("blend")
    dxSetRenderTarget()
    local pixels = dxGetTexturePixels(rt, 0, 0, w, h)

    local tex = dxCreateTexture(w, h)
    dxSetTexturePixels(tex, pixels)

    if isElement(shader) then
        destroyElement(shader)
    end
    shader = nil
    if isElement(rt) then
        destroyElement(rt)
    end
    rt = nil

    pixels = nil
    collectgarbage("collect")

	return tex
end

local gradientCache = {}
function getGradient(w, h, r, g, b, r2, g2, b2, rotation)
    local fileName = "gradients/" .. table.concat({w, h, r, g, b, r2, g2, b2, rotation}, "-") .. ".png"
    if not gradientCache[fileName] then
        gradientCache[fileName] = fileExists(fileName)

        if not gradientCache[fileName] then
            local tex = createGradient(w, h, r, g, b, r2, g2, b2, rotation)

            if tex then
                local pixels = dxGetTexturePixels(tex)
                pixels = dxConvertPixels(pixels, "png", 100)

                local file = fileCreate(fileName)
                fileWrite(file, pixels)
                fileClose(file)

                pixels = nil
                destroyElement(tex)
                tex = nil
                collectgarbage("collect")
            end
        end
    end
    return fileName
end