NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# This plot combines question 4 and question 2.
# In question 4, we were asked for coal combustion related sources. Here the question is for all vehicle sources,
# which I'm going to select by requiring that the Data.Category in the SCC data be "Onroad". This is much easier
# than in plot 4...

mycodeslevels = SCC[SCC$Data.Category == "Onroad", "SCC"]
mycodes = levels(mycodeslevels)[mycodeslevels]

# Defined a function that can be used to subset the NEI data
selectMyCodes <- function(code) {
  code %in% mycodes
}

# Get only the Baltimore data as the selection using the SCC codes is a bit slow
NEIbaltimore = NEI[NEI$fips == "24510", c("SCC", "Emissions", "year")]

codeselector = sapply(NEIbaltimore$SCC, selectMyCodes)
# Vehicles in Baltimore:
NEIveh = NEIbaltimore[codeselector, ]

# From here, basically repeat the code from plot 1:
# - split by year
# - sum everything within one year
# - plot it
splitdata = split(NEIveh$Emissions, coalNEI$year)
sums = sapply(splitdata, sum)
df = data.frame(names(sums), sums)
names(df) = c("year","totals")

png("plot5.png")
plot(df$year, df$totals, main="Vehicle emissions in Baltimore City", ylab="Emissions", xlab="Year")
dev.off()
