import
  math

import
  ../../assets/asset,
  ../../assets/asset_types,
  texture

export TextureRegion

proc setRegionInternal(textureRegion: TextureRegion; u, v, u2, v2: var float) =
  var
    texWidth: int = textureRegion.texture.width
    texHeight: int = textureRegion.texture.height

  textureRegion.regionWidth = int round(abs(u2 - u) * float texWidth)
  textureRegion.regionHeight = int round(abs(v2 - v) * float texHeight)
  ##  For a 1x1 region, adjust UVs toward pixel center to avoid filtering artifacts on AMD GPUs when drawing very stretched.
  if textureRegion.regionWidth == 1 and textureRegion.regionHeight == 1:
    let adjustX: float = 0.25 / float texWidth
    u += adjustX
    u2 -= adjustX
    let adjustY: float = 0.25 / float texHeight
    v += adjustY
    v2 -= adjustY
  textureRegion.u = u
  textureRegion.v = v
  textureRegion.u2 = u2
  textureRegion.v2 = v2

proc setRegion*(textureRegion: TextureRegion, x, y, width, height: float) =
  let invTexWidth = 1.0 / float textureRegion.texture.width
  let invTexHeight = 1.0 / float textureRegion.texture.height
  var u = x * invTexWidth
  var v = y * invTexHeight
  var u2 = (x + width) * invTexWidth
  var v2 = (y + height) * invTexHeight

  setRegionInternal(textureRegion, u, v, u2, v2)

proc fromTexture*(texture: Texture, x, y, w, h: int): TextureRegion =
  result = TextureRegion(
    assetType: AssetType.TextureRegion,
    texture: texture
  )
  setRegion(result, x.float, y.float, w.float, h.float)

proc fromTexture*(texture: Texture, regionName: string, w, h: int, u, u2, v, v2: float): TextureRegion = 
  result = TextureRegion(assetType: AssetType.TextureRegion)
  result.texture = texture
  result.name = regionName
  result.regionWidth = w
  result.regionHeight = h
  result.u = u
  result.u2 = u2
  result.v = v
  result.v2 = v2