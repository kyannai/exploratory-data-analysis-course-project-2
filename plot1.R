library(dplyr)

# Lead datasets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# group and get sum of Emissions by year
NEI_group_year <- group_by(NEI,year)
NEI_group_year_summary <- summarize(NEI_group_year, total = sum(Emissions))
NEI_group_year_summary <- mutate(NEI_group_year_summary, PM_kilo = round(total/1000,2))

# plot barchart by x=year, y=PM_kilo
par(mfrow=c(1,1))
barplot(NEI_group_year_summary$PM_kilo, names.arg=NEI_group_year_summary$year,
        main=expression('Total Emission of PM'[2.5]),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))

dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()
cat("plot1.png has been saved in", getwd())