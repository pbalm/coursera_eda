NEI <- readRDS("summarySCC_PM25.rds")

tdata = NEI[NEI$fips == "24510", c("Emissions", "year")]
splitdata = split(tdata$Emissions, tdata$year)
sums = sapply(splitdata, sum)
df = data.frame(names(sums), sums)
names(df) = c("year","totals")

png("plot2.png")
plot(df$year, df$totals, main="Overall PM2.5 emissions Baltimore City", ylab="Total emissions per year", xlab="Year")
dev.off()
