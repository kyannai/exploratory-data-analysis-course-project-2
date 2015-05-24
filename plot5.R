library(dplyr)
library(ggplot2)

# Lead datasets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# filter NEI data by fips = '24510' and type = 'ON-ROAD'
NEI_24510 <- filter(NEI, fips=='24510')
NEI_24510_ONROAD <- filter(NEI_24510, type=="ON-ROAD")

# group and get sum of Emissions by year
NEI_group_year <- group_by(NEI_24510_ONROAD,year)
NEI_group_year_summary <- summarize(NEI_group_year, total = sum(Emissions))
NEI_group_year_summary <- mutate(NEI_group_year_summary, PM_kilo = round(total/1000,2))

# plot barchart by x=year, y=PM_kilo
ggplot(NEI_group_year_summary, aes(year, PM_kilo)) +
  geom_line() + geom_point() +
  labs(title = "Total Emissions from Coal Combustion-Related Sources",
       x = "Year", y = expression("Total PM"[2.5]*" Emission (Tons)"))

barplot(NEI_group_year_summary$PM_kilo, names.arg=NEI_group_year_summary$year,
        main=expression('Total Emission of PM'[2.5]),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))

dev.copy(png, file="plot5.png", width=480, height=480)
dev.off()
cat("plot5.png has been saved in", getwd())