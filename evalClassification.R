library(terra)
library(sf)

reference <- "C:/Maxwell_Data/topo_data/topo_dl_data/topo_dl_data/all_mines/KY_Beverly_708161_1979_24000_geo.shp"
predicted <- "C:/Maxwell_Data/Dropbox/predictions3/KY_Beverly_708161_1979_24000_geo.tif"
predicted <- rast(predicted)
reference <- st_read(reference)

evalClassification <- function(reference, predicted, truth_dtype="Vector", 
                               codes="codes", background = 0, mappings,
                               positive_case=mappings[1]){
  
  require(terra)
  require(caret)
  require(diffeR)
  require(rfUtilities)

  if(truth_dtype =="Vector"){
    predG <- predicted
    ref2 <- vect(reference)
    ref3 <- terra::project(ref2, predG)
    refG <- terra::rasterize(ref3, predG, field=codes, background=background)
  }else{
    predG <- predicted
    refG <- reference
  }
  stacked <- c(predG, refG)
  ctab <- crosstab(stacked, useNA=FALSE)
  colnames(ctab) <- mappings
  rownames(ctab) <- mappings
  dimnames(ctab) <- setNames(dimnames(ctab),c("Predicted", "Reference"))
  cm <- caret::confusionMatrix(ctab, mode="everything", positive=positive_case)
  rfu <- rfUtilities::accuracy(ctab)
  Error <- overallDiff(ctab)/sum(ctab)
  Allocation <- overallAllocD(ctab)/sum(ctab)
  Quantity <- overallQtyD(ctab)/sum(ctab)
  Exchange <- overallExchangeD(ctab)/sum(ctab)
  Shift <- overallShiftD(ctab)/sum(ctab)
  
  final_metrics <- list(ConfusionMatrix=cm$table, 
                        overallAcc=cm$overall, 
                        ClassAcc=cm$byClass, 
                        UsersAcc = rfu$users.accuracy/100,
                        ProducersAcc = rfu$producers.accuracy/100,
                        Pontius = data.frame(Error, Allocation, Quantity, Exchange, Shift),
                        Classes=mappings,
                        PostiveCase=cm$positive)
  return(final_metrics)
}

func_test <- evalClassification(reference=reference, 
                        predicted=predicted, 
                        truth_dtype="Vector", 
                        codes="codes", 
                        background = 0, 
                        mappings=c("Not Mining", "Mining"),
                        positive_case="Mining")
