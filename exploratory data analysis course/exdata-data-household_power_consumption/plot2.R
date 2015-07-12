##read data

file <- read.table("./household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", colClasses="character")

##select observations for desired dates

file1 <- filter(file, (Date == "1/2/2007" | Date == "2/2/2007"))

##create date/time field in date/time format

file1$Date <- as.Date(file1$Date, format = "%d/%m/%Y")

library(dplyr)

file2 <- mutate(file1, datetimes = paste(Date, Time))

file2$datetimes <- strptime(file2$datetimes, format="%Y-%m-%d %H:%M:%S")

##create Plot 2

png(file = "plot2.png")

plot(file2$datetimes, as.numeric(file2$Global_active_power), xlab = "", ylab = "Global Active Power (kilowatts)", type = "n")

lines(file2$datetimes, as.numeric(file2$Global_active_power))

dev.off()