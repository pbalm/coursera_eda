NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# I'm going to use the EI.Sector column from the SCC data. This has several elements, for example:
# Fuel Comb - Comm/Institutional - Coal
#
# I can find the coal-combustion related sources by splitting this string by the dashes and taking
# the last element. The SCC column in the SCC data has the codes, which I then use to subset the
# NEI data to those emissions from coal-combustion related sources.

eisector = SCC$EI.Sector

# Define a function that will get the last element of the string in the EI.Sector column
getCombustible = function(sector) {
  if(is.na(sector)) {
    "NA"
  } else {
    elems = unlist(strsplit(as.character(sector), "-"))
    # the last one would be "Coal"
    comb = elems[length(elems)]
    # Remove any trailing or leading spaces
    gsub(" ", "", comb)
  }
}

# combustible is a column that has "Coal", "Oil", etc.
combustible = sapply(eisector, getCombustible)

myscc = data.frame(SCC$SCC, combustible)
mycodeslevels = myscc[myscc$combustible == "Coal", "SCC.SCC"]
# mycodes are the codes for which combustible was "Coal"
mycodes = levels(mycodeslevels)[mycodeslevels]

# Defined a function that can be used to subset the NEI data
selectMyCodes <- function(code) {
    code %in% mycodes
}

codeselector = sapply(NEI$SCC, selectMyCodes)
coalNEI = NEI[codeselector, c("year", "Emissions")]

# From here, basically repeat the code from plot 1:
# - split by year
# - sum everything within one year
# - plot it
splitdata = split(coalNEI$Emissions, coalNEI$year)
sums = sapply(splitdata, sum)
df = data.frame(names(sums), sums)
names(df) = c("year","totals")

png("plot4.png")
plot(df$year, df$totals, main="Coal-combustion related emissions", ylab="Emissions", xlab="Year")
dev.off()
