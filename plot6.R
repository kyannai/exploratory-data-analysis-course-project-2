library(dplyr)
library(ggplot2)

# Lead datasets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# filter NEI data by fips = '24510' and type = 'ON-ROAD'
NEI_24510 <- filter(NEI, fips=='24510')
NEI_24510_ONROAD <- filter(NEI_24510, type=="ON-ROAD")

# group and get sum of Emissions by year
NEI_group_24510_year <- group_by(NEI_24510_ONROAD,year)
NEI_group_year_24510_summary <- summarize(NEI_group_24510_year, total = sum(Emissions))
NEI_group_year_24510_summary <- mutate(NEI_group_year_24510_summary, PM_kilo = round(total/1000,2))
NEI_group_year_24510_summary$city <- "Baltimore City"

# filter NEI data by fips = '06037' and type = 'ON-ROAD'
NEI_06037 <- filter(NEI, fips=='06037')
NEI_06037_ONROAD <- filter(NEI_06037, type=="ON-ROAD")

# group and get sum of Emissions by year
NEI_group_06037_year <- group_by(NEI_06037_ONROAD,year)
NEI_group_year_06037_summary <- summarize(NEI_group_06037_year, total = sum(Emissions))
NEI_group_year_06037_summary <- mutate(NEI_group_year_06037_summary, PM_kilo = round(total/1000,2))
NEI_group_year_06037_summary$city <- "Los Angeles"

# combine both data set into one
NEI_group_year_both_summary <- rbind(NEI_group_year_24510_summary, NEI_group_year_06037_summary);

# plot the graph
ggplot(NEI_group_year_both_summary, aes(x=factor(year), y=PM_kilo, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))


dev.copy(png, file="plot6.png", width=480, height=480)
dev.off()
cat("plot6.png has been saved in", getwd())