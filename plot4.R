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

#Set display to PNG plot 4
png("Plot4.png")

datetime = c(1,1440,2880)

#setup multiple columns for printing
par(mfcol = c(2,2))

#plot first graph
plot(data$Global_active_power, type ="l", 
    xaxt = 'n', xlab = "", ylab = "Global active power (kilowatts)")
axis(1, at = datetime, labels = c("Thu", "Fri", "Sat"))

#plot second graph
plot(data$Sub_metering_1, type ="l", 
    xaxt = 'n', xlab = "", ylab = "Energy sub metering") 
axis(1, at = datetime, labels = c("Thu", "Fri", "Sat"))

#add additional required line graphs to second plot
lines(data$Sub_metering_2, type ="l", col = "red")
lines(data$Sub_metering_3, type ="l", col = "blue")

#add legend to second graph
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    col = c("black", "red", "blue"), lwd = 1, bty = "n")

#plot third graph
plot(data$Voltage, type ="l", 
    xaxt = 'n', xlab = "datetime", ylab = "Voltage")
axis(1, at = datetime, labels = c("Thu", "Fri", "Sat"))

#plot fourth graph
plot(data$Global_reactive_power, type ="l", 
    xaxt = 'n', xlab = "datetime", ylab = "Global reactive power")
axis(1, at = datetime, labels = c("Thu", "Fri", "Sat"))

dev.off()