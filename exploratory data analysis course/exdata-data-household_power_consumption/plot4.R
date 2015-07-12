##read data

file <- read.table("./household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", colClasses="character")

##select observations for desired dates

file1 <- filter(file, (Date == "1/2/2007" | Date == "2/2/2007"))

##create date/time field in date/time format

file1$Date <- as.Date(file1$Date, format = "%d/%m/%Y")

library(dplyr)

file2 <- mutate(file1, datetimes = paste(Date, Time))

file2$datetimes <- strptime(file2$datetimes, format="%Y-%m-%d %H:%M:%S")

##create file with Sub_metering type as factor

submeter1_file <- select(file2, Sub_metering = Sub_metering_1, datetimes)
submeter2_file <- select(file2, Sub_metering = Sub_metering_2, datetimes)
submeter3_file <- select(file2, Sub_metering = Sub_metering_3, datetimes)
submeter1_file <- mutate(submeter1_file, submeter = "Sub_metering_1")
submeter2_file <- mutate(submeter2_file, submeter = "Sub_metering_2")
submeter3_file <- mutate(submeter3_file, submeter = "Sub_metering_3")

submeter_file <- rbind(submeter1_file, submeter2_file, submeter3_file)
submeter_file$submeter <- as.factor(submeter_file$submeter)

##create plot 4

png(file = "plot4.png")


par(mfrow=c(2,2))

#add global active power plot
plot(file2$datetimes, as.numeric(file2$Global_active_power), xlab = "", ylab = "Global Active Power (kilowatts)", type = "n")
lines(file2$datetimes, as.numeric(file2$Global_active_power))

#add voltage plot
plot(file2$datetimes, as.numeric(file2$Voltage), xlab = "datetime", ylab = "Voltage", type = "n")
lines(file2$datetimes, as.numeric(file2$Voltage))

#add energy sub metering plot
with(submeter_file, plot(datetimes,Sub_metering, xlab = "", ylab="Energy sub metering", type="n"))
with(subset(submeter_file, submeter=="Sub_metering_1"), lines(datetimes,Sub_metering, col="black"))
with(subset(submeter_file, submeter=="Sub_metering_2"), lines(datetimes,Sub_metering, col="red"))
with(subset(submeter_file, submeter=="Sub_metering_3"), lines(datetimes,Sub_metering, col="blue"))
legend("topright", lwd=1, col=c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#add global reactive power plot
plot(file2$datetimes, as.numeric(file2$Global_reactive_power), xlab = "datetime", ylab = "Global_reactive_power", type = "n")
lines(file2$datetimes, as.numeric(file2$Global_reactive_power))

dev.off()
