makeMasks <- function(image, features, extent, field, background, outImage, outMask){
  require(terra)
  
  imgData <- rast(image)
  extData <- vect(extent)
  featData <- vect(feastures)
  
  extCRS <- project(extData, imgData)
  featCRS <- project(featData, imgData)

  mineR <- rasterize(minesCRS, topo_crop, field=field, background=background)
  
  writeRaster(topo_crop, outImage)
  writeRaster(mineR, outMask)
}