
############################
##  informant distances   ##
############################

library(dtw)
iData <- read.delim("~/Desktop/Analysis/informant/iData.txt")
iData

#subset and re-factor (gets rid of unused levels to see where missing values are)
gi01 <- subset(iData, pID == "gi01")
gi01$ITEM <- factor(gi01$ITEM)
gi02 <-subset(iData,pID == "gi02")
gi02$ITEM <- factor(gi02$ITEM)
gi03 <- subset(iData, pID == "gi03")
gi03$ITEM <- factor(gi03$ITEM)
gi04 <-subset(iData, pID == "gi05")
gi04$pID <-factor(gi04$ITEM)

items <-levels(gi01$ITEM)


#for item in gi01, get distance to item in gi02,gi03,gi04: 

#distances calculated on shoulders, elbows and wrists (collarbone is always identical anyway)
item <- 1

gesture1 <- gi01[gi01$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]

gesture2 <- gi02[gi02$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]

gesture3 <- gi03[gi03$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]

gesture4 <- gi04[gi04$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]




#gi01 distances
dist1 <-dtw(gesture1,gesture2)$normalizedDistance
dist2 <-dtw(gesture1,gesture3)$normalizedDistance
dist3 <-dtw(gesture1,gesture4)$normalizedDistance
dist_01 <- mean(c(dist1,dist2,dist3), na.rm = TRUE)

#gi02 distances
dist4 <-dtw(gesture2,gesture1)$normalizedDistance
dist5 <-dtw(gesture2,gesture3)$normalizedDistance
dist6 <-dtw(gesture2,gesture4)$normalizedDistance
dist_02 <- mean(c(dist4,dist5,dist6), na.rm = TRUE)

#gi03 distances
dist7 <-dtw(gesture3,gesture1)$normalizedDistance
dist8 <-dtw(gesture3,gesture2)$normalizedDistance
dist9 <-dtw(gesture3,gesture4)$normalizedDistance
dist_03 <- mean(c(dist7,dist8,dist9),na.rm = TRUE)

#gi04 distances
dist10 <-dtw(gesture4,gesture1)$normalizedDistance
dist11 <-dtw(gesture4,gesture2)$normalizedDistance
dist12 <-dtw(gesture4,gesture3)$normalizedDistance
dist_04 <- mean(c(dist10,dist11,dist12), na.rm = TRUE)




temprow1 <- matrix(c("i01", items[item], dist_01), nrow = 1)
temprow1 <- data.frame(temprow1)
colnames(temprow1) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow1

temprow2 <- matrix(c("i02", items[item], dist_02), nrow = 1)
temprow2 <- data.frame(temprow2)
colnames(temprow2) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow2

temprow3 <- matrix(c("i03", items[item], dist_03), nrow = 1)
temprow3 <- data.frame(temprow3)
colnames(temprow3) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow3

temprow4 <- matrix(c("i04", items[item], dist_04), nrow = 1)
temprow4 <- data.frame(temprow4)
colnames(temprow4) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow4

#create the dataframe for distances to go into
iDistances <- rbind(temprow1,temprow2,temprow3,temprow4)
iDistances



#iterate through the rest of the items in a foor loop

for( x in 2:32) {
  item <- x

gesture1 <- gi01[gi01$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]

gesture2 <- gi02[gi02$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]

gesture3 <- gi03[gi03$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]

gesture4 <- gi04[gi04$ITEM == items[item], c("RSX", "RSY", "LSX", "LSY",
                                             "REX", "REY", "LEX", "LEY",
                                             "RWX", "RWY", "LWX", "LWY")]




#gi01 distances
dist1 <- NA
tryCatch({dist1 <-dtw(gesture1,gesture2)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist2 <- NA
tryCatch({dist2 <-dtw(gesture1,gesture3)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist3 <- NA
tryCatch({dist3 <-dtw(gesture1,gesture4)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist_01 <- mean(c(dist1,dist2,dist3),na.rm = TRUE)

#gi02 distances
dist4 <-NA
tryCatch({dist4 <-dtw(gesture2,gesture1)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist5 <-NA
tryCatch({dist5 <-dtw(gesture2,gesture3)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist6 <-NA
tryCatch({dist6 <-dtw(gesture2,gesture4)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist_02 <- mean(c(dist4,dist5,dist6),na.rm = TRUE)

#gi03 distances
dist7 <-NA
tryCatch({dist7 <-dtw(gesture3,gesture1)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist8 <-NA
tryCatch({dist8 <-dtw(gesture3,gesture2)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist9 <- NA
tryCatch({dist9 <-dtw(gesture3,gesture4)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist_03 <- mean(c(dist7,dist8,dist9),na.rm = TRUE)

#gi04 distances
dist10 <- NA
tryCatch({dist10 <-dtw(gesture4,gesture1)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist11 <- NA
tryCatch({dist11 <-dtw(gesture4,gesture2)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist12 <- NA
tryCatch({dist12 <-dtw(gesture4,gesture3)$normalizedDistance}, error = function(e){cat("not possible", conditionMessage(e), "\n")})
dist_04 <- mean(c(dist10,dist11,dist12),na.rm = TRUE)




temprow1 <- matrix(c("i01", items[item], dist_01), nrow = 1)
temprow1 <- data.frame(temprow1)
colnames(temprow1) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow1

temprow2 <- matrix(c("i02", items[item], dist_02), nrow = 1)
temprow2 <- data.frame(temprow2)
colnames(temprow2) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow2

temprow3 <- matrix(c("i03", items[item], dist_03), nrow = 1)
temprow3 <- data.frame(temprow3)
colnames(temprow3) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow3

temprow4 <- matrix(c("i04", items[item], dist_04), nrow = 1)
temprow4 <- data.frame(temprow4)
colnames(temprow4) <- c("PID", "ITEM", "MEAN_DIST_TO_OTHERS")
temprow4


iDistances <- rbind(iDistances, temprow1,temprow2,temprow3,temprow4)
iDistances

}


length(levels(iDistances$ITEM))



##add column specifying which items are iconic

iconic <- c( "iron", 
             "perfume", 
             "jacket", 
             "belt", 
             "tree", 
             "rhino", 
             "tie", 
             "lightbulb", 
             "cards", 
             "curtains",
             "clock",
             "kangaroo", 
             "queue", 
             "time", 
             "icecream", 
             "bicycle")


iDistances$ICONIC <- ifelse(iDistances$ITEM %in% toupper(iconic),1,0)



