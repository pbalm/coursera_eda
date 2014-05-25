NEI <- readRDS("summarySCC_PM25.rds")

tdata = NEI[, c("Emissions", "year")]
splitdata = split(tdata$Emissions, tdata$year)
sums = sapply(splitdata, sum)
df = data.frame(names(sums), sums)
names(df) = c("year","totals")

png("plot1.png")
plot(df$year, df$totals, main="Overall PM2.5 emissions", ylab="Total emissions per year", xlab="Year")
dev.off()
