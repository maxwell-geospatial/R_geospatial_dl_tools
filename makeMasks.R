makeMasks <- function(image, features, crop=FALSE, extent, field, background, outImage, outMask, mode="Both"){
  require(terra)
  
  imgData <- rast(image)
  featData <- vect(feastures)
  
  extCRS <- project(extData, imgData)
  featCRS <- project(featData, imgData)
  if (crop==TRUE){
    extCRS <- project(extData, imgData)
    imgData <- crop(imgData, vect(extent))
  }
  mineR <- rasterize(minesCRS, imgData, field=field, background=background)
  if (mode=="Both") {
    writeRaster(topo_crop, outImage)
    writeRaster(mineR, outMask)
  } else if (mode="Mask") {
    writeRaster(mineR, outMask)
  } else{
    print("Invalid Mode.")
  }
}