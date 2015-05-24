library(dplyr)
library(ggplot2)


# Lead datasets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# filter NEI data by SCC contains 'coal' or 'comb'
SCC_comb_coal <- filter(SCC, grepl("Comb.*Coal",Short.Name))

# merge SCC_coal with NEI 
NEI_comb_coal <- merge(x=NEI, y=SCC_comb_coal, by='SCC')

# group and get sum of Emissions by year
NEI_group_year <- group_by(NEI_comb_coal,year)
NEI_group_year_summary <- summarize(NEI_group_year, total = sum(Emissions))
NEI_group_year_summary <- mutate(NEI_group_year_summary, PM_kilo = round(total/1000,2))

# plot line chart by x=year, y=PM_kilo
ggplot(data=NEI_group_year_summary, aes(x=year, y=PM_kilo)) + 
  geom_line(aes(group=1, col=PM_kilo)) + geom_point(aes(size=2, col=PM_kilo)) + 
  ggtitle(expression('Total Emissions of PM'[2.5])) + 
  ylab(expression(paste('PM', ''[2.5], ' in kilotons'))) + 
  geom_text(aes(label=PM_kilo, size=2, hjust=1.5, vjust=1.5)) + 
  theme(legend.position='none') + scale_colour_gradient(low='black', high='red')

ggplot(NEI_group_year_summary, aes(year, PM_kilo)) +
  geom_line() + geom_point() +
  labs(title = "Total Emissions from Coal Combustion-Related Sources",
       x = "Year", y = expression("Total PM"[2.5]*" Emission (Tons)"))

dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
cat("plot4.png has been saved in", getwd())