# Default projection of the map can be found by running the following on the SpatialPolyGonsDataFrame.
install.packages("raster")

raster::crs(county)

us.map <- spTransform(state, CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
