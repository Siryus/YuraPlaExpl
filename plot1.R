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


#plot number 1
png(file = "plot1.png", height = 480, width = 480)
hist(x = dat$Global_active_power,
     freq = 0.5,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     col = "red")
dev.off()