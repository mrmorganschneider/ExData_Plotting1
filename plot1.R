#NOTE: All data loading and processing is completed
#in the load_data.R file.

#read previously formatted data into system
library(tidyverse, help, pos = 2, lib.loc = NULL)

if(!file.exists("power_data.zip")){

    fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, destfile = "power_data.zip", method = "curl" )
    unzip("power_data.zip")
}

#read and remove excess lines from dataset
input <- as_tibble(read.delim("household_power_consumption.txt", header = TRUE, sep = ";"))
input$Date <- as.Date(input$Date, format='%d/%m/%Y')
formattedData <- subset(input, Date == "2007-02-01" | Date == "2007-02-02")

#Format columns to numeric type
formattedData <- mutate(formattedData, Global_active_power = as.numeric(Global_active_power),
    Global_reactive_power = as.numeric(Global_reactive_power),
    Voltage = as.numeric(Voltage),
    Global_intensity = as.numeric(Global_intensity),
    Sub_metering_1 = as.numeric(Sub_metering_1),
    Sub_metering_2 = as.numeric(Sub_metering_2),
    Sub_metering_3 = as.numeric(Sub_metering_3))

saveRDS(formattedData,"formattedData.rds")
data <- as_tibble(readRDS("formattedData.rds"))

#Set display to PNG plot 1
png("Plot1.png")

#Create Plot 1
hist(data$Global_active_power, col="red", 
    main = "Global Active Power",
    xlab = "Global Active Power (Kilowatts)")

#Return display to windows
dev.off()
windows()