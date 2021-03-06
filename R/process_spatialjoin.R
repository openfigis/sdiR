#
# Scripts to proceed to a spatial join applied to
# a point dataset and fishing areas
# 
# @author eblondel
# @date 2015/10/16
#

#required packages
library(RFigisGeo)

#point data
data <- read.csv("input.csv", h=T)
spdf <- toSpatialPoints(data, lonlat = c("Lon", "Lat"))

#values to consider for filtering on Fishing area level
fareas <- readWFS("http://www.fao.org/figis/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=fifao:FAO_AREAS_ERASE")
fareaLevels <- unique(fareas@data$F_LEVEL)
print(fareaLevels)

#proceed to the spatial join and write outputs for all levels except F_SUBUNIT
for(i in 1:(length(fareaLevels)-1)){
	#proceed to the spatial join
	output <- joinByArea(spdf, fareas, "F_CODE", filter = list(key = "F_LEVEL", value = fareaLevels[i]), na.rm = TRUE)
	result <- as.data.frame(output)

	#write result
	write.csv(result, file = paste0("output_", tolower(fareaLevels[i]), ".csv"), row.names = FALSE)
}
