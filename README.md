# Geospatial Deep Learning Utilities

The goal of this repository is to describe and make available some utility functions for undertaking geospatial deep learning in the R data science environment. This is a work in progress, and we hope to continue to update the repo with new functions and tools. Here, we provide an explanation of the current functions made available. 

These tools primarily rely on [terra](https://github.com/rspatial/terra) for raster data reading and processing, [imager](https://github.com/dahtah/imager) for image manipulation and writing, and [sf](https://github.com/r-spatial/sf) for vector data handling. Validation metrics are calculated using functions available in [caret](https://github.com/topepo/caret), [diffeR](https://github.com/amsantac/diffeR), and [rfUtilities](https://github.com/jeffreyevans/rfUtilities).

## makeMasks()

This function can be used to make raster masks for semantic segmentation problems from input vector data. A field can be specified, which contains the numeric code for each class. You can also define a background value. Output will be a raster with the same spatial extent as the input raster data or imagery. You can also specify an extent object to reduce the spatial extent of the mask. 

* image: path to input raster image data 
* features: path to vector features representing classes
* extent: extent in which to generate raster masks and clip input image data. Should be a vector file. 
* field: field or attribute from vector data that differentiates the classes. These should be numeric codes as opposed to character-based labels. In the case of binary classification, you can also specify a constant numeric value. 
* background: code to use for background if the mask data are not wall-to-wall. This should be a new value that does not overlap with your class codes (unless you would like to assign all the background cells to an existing class).
* outImage: path and name of output image with file extension. If an extent is defined, input image will be clipped to this extent.
* outMask: path and name of output mask with file extension.
* mode: If "Both" export both mask and copy of image. If "Mask", just export mask. Should use "Both" if an extent is defined. 

## chipIt()

Generate image chips from an input image and raster mask for semantic segmentation, such as a mask generated with makeMasks(). Resulting image chips and masks are saved as a folder directory. 

* image: raster dataset to generate image chips from.
* mask: mask raster dataset to generate mask chips from. Should have the same spatial extent as the image with a unique code differentiating each class. 
* size: size of image chips in x- and y- directions as number of pixels. Default is 256. 
* stride_x: stride in the x direction. Default is 256. When stride_x is equal to the size argument, chips will not overlap in the x direction. 
* stride_y: stride in the y direction. Default is 256. When stride_y is equal to the size argument, chips will not overlap. 
* outDir: Output directory to write chips to. If the required subfolders do not exist within the directory, the script will create them. 
* mode: Three modes are possible: "All", "Positive", or "Divided". "All" mode writes all chips, even if the chip only represents the background class. Images chips are written to the specified directory and the "images" subfolder while masks are written to the "masks" subfolder. "Positive" mode writes only chips with present or non-background pixels. Images chips are written to the specified directory and the "images" subfolder while masks are written to the "masks" subfolder. "Divided" separates background-only chips from those containing some present or non-background cells. Images chips are written to the specified directory and the "images" subfolder while masks are written to the "masks" subfolder. Withing the subfolders, the two groups are written to separate "positive" and "background" folders. Images and associated chips will have the same filename using all modes. 

As a note, the last row and column of chips will likely not have a full set of rows and columns. So, chips occurring in the last row and/or column are migrated backward to have a full set of the desired rows and columns. So, they will overlap with adjacent chips. This allows for all pixels within the image extent to be represented in the produced chips. 

## evalClassification()

Generate evaluation metrics for semantic segmentation, including both binary classification and multiclass classification. The following metrics are calculated: overall accuracy, Kappa, recall, precision, F1 score, specificity, negative predictive value, user's accuracy, producer's accuracy, overall error, allocation disagreement, quantity disagreement, exchange disagreement, and shift disagreement. 

* reference: reference data to compare result to. Can be provided as a vector or raster representation. 
* predicted: prediction result as a raster grid. Probabilities must be converted to a "hard" classification.
* truth_dtype: Either "Vector" or "Raster". This allows for the reference data to be provided as eitehr a vector or a raster. Predicted must be a raster. Default is "Vector".
* codes: If the reference data are provided as a vector, specify numeric field differentiating classes. Must be numeric as opposed to character labels. 
* background: value representing background class. Default is 0.
* mappings: class names corresponding to the numeric codes. Must be in the same order as the numeric codes and have the same length.
* postive_class: Numeric code representing postive case. This is only used or relevant in binary classification problems. Default is the first class. 

