library (dplyr)
library (lubridate)

#reading data
con <- file("household_power_consumption.txt", open="rt")
dat <- NULL
while (length((dat_part <- read.csv(con, sep=";", nrows = 1000, header=FALSE))[,1]) > 0){ 
  dat_part <- mutate(dat_part, V1=as.Date(V1, '%d/%m/%Y'))
  dat_part <- filter(dat_part, V1 >= as.Date("01.02.2007", '%d.%m.%Y') & V1 <= as.Date("02.02.2007", '%d.%m.%Y'))
  if(length(dat_part[,1])>0)
    dat <- rbind(dat, dat_part);
}

#making data tidy
titles <- read.csv("household_power_consumption.txt", sep=";", nrows = 1, header=TRUE)
colnames(dat) <- colnames(titles)
dat <- mutate(dat, Date = as.character(Date), Time = as.character(Time))
dat <- mutate(dat, Date = paste(Date, Time))
dat <- mutate(dat, Date = as.POSIXct(Date, '%Y-%m-%d %H:%M:%S'))

#plot number 3
png(file = "plot3.png", height = 480, width = 480)
plot(x = dat$Date,
     y = dat$Sub_metering_1,
     ylab = "Energy sub metering",
     xlab = "",
     type = "l",
     col = "black")
points(x = dat$Date,
       y = dat$Sub_metering_2,
       type = "l",
       col = "red")
points(x = dat$Date,
       y = dat$Sub_metering_3,
       type = "l",
       col = "blue")
legend("topright",
       lty = 1,
       legend = c("Sum_metering_1", "Sum_metering_2", "Sum_metering_3"),
       col = c("black", "red", "blue"))
dev.off()