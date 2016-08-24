  #script for scaling participant skeletons to informant size

#read in informant files and bind to single dataframe
setwd("~/Desktop/Analysis/informant")
filenames <- dir(path = "~/Desktop/Analysis/informant")
iData <- read.delim("~/Desktop/Analysis/informant/iData.txt")

  #informant torso
iCBY <- mean(iData$CBY) #informant avg collarbone coordinate
iTY <- mean(iData$TY) #informant avg torso Y coordinate

rm(iData)


#read in files
gp01 <- read.delim("~/Desktop/Analysis/participants/gp01.txt")
gp02 <- read.delim("~/Desktop/Analysis/participants/gp02.txt")
gp03 <- read.delim("~/Desktop/Analysis/participants/gp03.txt")
gp04 <- read.delim("~/Desktop/Analysis/participants/gp04.txt")
gp06 <- read.delim("~/Desktop/Analysis/participants/gp06.txt")
gp07 <- read.delim("~/Desktop/Analysis/participants/gp07.txt")
gp08 <- read.delim("~/Desktop/Analysis/participants/gp08.txt")
gp09 <- read.delim("~/Desktop/Analysis/participants/gp09.txt")
gp10 <- read.delim("~/Desktop/Analysis/participants/gp10.txt")
gp11 <- read.delim("~/Desktop/Analysis/participants/gp11.txt")
gp12 <- read.delim("~/Desktop/Analysis/participants/gp12.txt")
gp13 <- read.delim("~/Desktop/Analysis/participants/gp13.txt")
gp14 <- read.delim("~/Desktop/Analysis/participants/gp14.txt")
gp15 <- read.delim("~/Desktop/Analysis/participants/gp15.txt")
gp15 <- read.delim("~/Desktop/Analysis/participants/gp15.txt")
gp16 <- read.delim("~/Desktop/Analysis/participants/gp16.txt")
gp17 <- read.delim("~/Desktop/Analysis/participants/gp17.txt")
gp18 <- read.delim("~/Desktop/Analysis/participants/gp18.txt")
gp19 <- read.delim("~/Desktop/Analysis/participants/gp19.txt")
gp20 <- read.delim("~/Desktop/Analysis/participants/gp20.txt")
gp21 <- read.delim("~/Desktop/Analysis/participants/gp21.txt")
gp22 <- read.delim("~/Desktop/Analysis/participants/gp22.txt")
gp23 <- read.delim("~/Desktop/Analysis/participants/gp23.txt")
gp24 <- read.delim("~/Desktop/Analysis/participants/gp24.txt")
gp25 <- read.delim("~/Desktop/Analysis/participants/gp25.txt")
gp26 <- read.delim("~/Desktop/Analysis/participants/gp26.txt")
gp27 <- read.delim("~/Desktop/Analysis/participants/gp27.txt")
gp28 <- read.delim("~/Desktop/Analysis/participants/gp28.txt")
gp29 <- read.delim("~/Desktop/Analysis/participants/gp29.txt")
gp30 <- read.delim("~/Desktop/Analysis/participants/gp30.txt")
gp31 <- read.delim("~/Desktop/Analysis/participants/gp31.txt")
gp32 <- read.delim("~/Desktop/Analysis/participants/gp32.txt")
gp33 <- read.delim("~/Desktop/Analysis/participants/gp33.txt")
gp34 <- read.delim("~/Desktop/Analysis/participants/gp34.txt")
gp35 <- read.delim("~/Desktop/Analysis/participants/gp35.txt")
gp36 <- read.delim("~/Desktop/Analysis/participants/gp36.txt")
gp37 <- read.delim("~/Desktop/Analysis/participants/gp37.txt")






  #participant torso
torsoList <- c() #empty list to hold mean torso Y coord for each participant
torsoList <-c(torsoList, mean(gp01$TY))
torsoList <-c(torsoList, mean(gp02$TY))
torsoList <-c(torsoList, mean(gp03$TY))
torsoList <-c(torsoList, mean(gp04$TY))
torsoList <-c(torsoList, mean(gp06$TY))
torsoList <-c(torsoList, mean(gp07$TY))
torsoList <-c(torsoList, mean(gp08$TY))
torsoList <-c(torsoList, mean(gp09$TY))
torsoList <-c(torsoList, mean(gp10$TY))
torsoList <-c(torsoList, mean(gp11$TY))
torsoList <-c(torsoList, mean(gp12$TY))
torsoList <-c(torsoList, mean(gp13$TY))
torsoList <-c(torsoList, mean(gp14$TY))
torsoList <-c(torsoList, mean(gp15$TY))
torsoList <-c(torsoList, mean(gp16$TY))
torsoList <-c(torsoList, mean(gp17$TY))
torsoList <-c(torsoList, mean(gp18$TY))
torsoList <-c(torsoList, mean(gp19$TY))
torsoList <-c(torsoList, mean(gp20$TY))
torsoList <-c(torsoList, mean(gp21$TY))
torsoList <-c(torsoList, mean(gp22$TY))
torsoList <-c(torsoList, mean(gp23$TY))
torsoList <-c(torsoList, mean(gp24$TY))
torsoList <-c(torsoList, mean(gp25$TY))
torsoList <-c(torsoList, mean(gp26$TY))
torsoList <-c(torsoList, mean(gp27$TY))
torsoList <-c(torsoList, mean(gp28$TY))
torsoList <-c(torsoList, mean(gp29$TY))
torsoList <-c(torsoList, mean(gp30$TY))
torsoList <-c(torsoList, mean(gp31$TY))
torsoList <-c(torsoList, mean(gp32$TY))
torsoList <-c(torsoList, mean(gp33$TY))
torsoList <-c(torsoList, mean(gp34$TY))
torsoList <-c(torsoList, mean(gp35$TY))
torsoList <-c(torsoList, mean(gp36$TY))
torsoList <-c(torsoList, mean(gp37$TY))



  #scaling factors
 sfList <-c() #empty list to hold scaling factor for each participant
for(i in 1:37) {
  sfList <-c(sfList, assign(paste0(i,"sF"), iTY/torsoList[i]))
}
 

#scale! 
gp01[,19:72] <- gp01[,19:72]*sfList[1]
gp02[,19:72] <- gp02[,19:72]*sfList[2]
gp03[,19:72] <- gp03[,19:72]*sfList[3]
gp04[,19:72] <- gp04[,19:72]*sfList[4]
gp06[,19:72] <- gp06[,19:72]*sfList[6]
gp07[,19:72] <- gp07[,19:72]*sfList[7]
gp08[,19:72] <- gp08[,19:72]*sfList[8]
gp09[,19:72] <- gp09[,19:72]*sfList[9]
gp10[,19:72] <- gp10[,19:72]*sfList[10]
gp11[,19:72] <- gp11[,19:72]*sfList[11]
gp12[,19:72] <- gp12[,19:72]*sfList[12]
gp13[,19:72] <- gp13[,19:72]*sfList[13]
gp14[,19:72] <- gp14[,19:72]*sfList[14]
gp15[,19:72] <- gp15[,19:72]*sfList[15]
gp16[,19:72] <- gp16[,19:72]*sfList[16]
gp17[,19:72] <- gp17[,19:72]*sfList[17]
gp18[,19:72] <- gp18[,19:72]*sfList[18]
gp19[,19:72] <- gp19[,19:72]*sfList[19]
gp20[,19:72] <- gp20[,19:72]*sfList[20]
gp21[,19:72] <- gp21[,19:72]*sfList[21]
gp22[,19:72] <- gp22[,19:72]*sfList[22]
gp23[,19:72] <- gp23[,19:72]*sfList[23]
gp24[,19:72] <- gp24[,19:72]*sfList[1]
gp25[,19:72] <- gp25[,19:72]*sfList[2]
gp26[,19:72] <- gp26[,19:72]*sfList[3]
gp27[,19:72] <- gp27[,19:72]*sfList[4]
gp28[,19:72] <- gp28[,19:72]*sfList[5]
gp29[,19:72] <- gp29[,19:72]*sfList[6]
gp30[,19:72] <- gp30[,19:72]*sfList[7]
gp31[,19:72] <- gp31[,19:72]*sfList[8]
gp32[,19:72] <- gp32[,19:72]*sfList[9]
gp33[,19:72] <- gp33[,19:72]*sfList[10]
gp34[,19:72] <- gp34[,19:72]*sfList[11]
gp35[,19:72] <- gp35[,19:72]*sfList[12]
gp36[,19:72] <- gp36[,19:72]*sfList[13]
gp37[,19:72] <- gp37[,19:72]*sfList[14]




#write to file 
setwd("~/Desktop/Analysis/scaled")
write.table(gp01, file = "sp01.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp02, file = "sp02.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp03, file = "sp03.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp04, file = "sp04.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp06, file = "sp06.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp07, file = "sp07.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp08, file = "sp08.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp09, file = "sp09.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp10, file = "sp10.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp11, file = "sp11.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp12, file = "sp12.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp13, file = "sp13.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp14, file = "sp14.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp15, file = "sp15.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp16, file = "sp16.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp17, file = "sp17.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp18, file = "sp18.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp19, file = "sp19.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp20, file = "sp20.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp21, file = "sp21.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp22, file = "sp22.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp23, file = "sp23.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp24, file = "sp24.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp25, file = "sp25.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp26, file = "sp26.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp27, file = "sp27.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp28, file = "sp28.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp29, file = "sp29.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp30, file = "sp30.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp31, file = "sp31.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp32, file = "sp32.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp33, file = "sp33.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp34, file = "sp34.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp35, file = "sp35.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp36, file = "sp36.txt", quote = FALSE, row.names = FALSE, sep = "\t")
write.table(gp37, file = "sp37.txt", quote = FALSE, row.names = FALSE, sep = "\t")



