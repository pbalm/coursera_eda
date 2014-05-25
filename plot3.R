NEI <- readRDS("summarySCC_PM25.rds")

library(ggplot2)
library(reshape)

tdata = NEI[NEI$fips == "24510", c("Emissions", "year", "type")]

getEmissionsPerYear <- function(tdata, type) {
  typedata = tdata[tdata$type == type,]
  splitdata = split(typedata$Emissions, typedata$year)
  sums = sapply(splitdata, sum)
  df = data.frame(names(sums), sums)
  names(df) = c("year", type)
  df
}

pointdf = getEmissionsPerYear(tdata, "POINT")
nonpointdf = getEmissionsPerYear(tdata, "NONPOINT")
onroaddf = getEmissionsPerYear(tdata, "ON-ROAD")
nonroaddf = getEmissionsPerYear(tdata, "NON-ROAD")

# merge all above dataframes
df = merge_recurse(list(pointdf, nonpointdf, onroaddf, nonroaddf), by = "year")

# now prepare the data for plotting
mdata <- melt(df, id=c("year"))
names(mdata) = c("year", "type", "emissions")

png("plot3.png")

g <- ggplot(mdata, aes(x= year, y=emissions, color = type))
g <- g + geom_point(size= 6)
g <- g + labs(title="Emissions in Baltimore City for different types")

print(g)
dev.off()
