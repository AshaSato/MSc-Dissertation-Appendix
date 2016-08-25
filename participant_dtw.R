#####################################
##  participant distance to target ##
####################################
library(dtw)
#get ian gestures
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

i_items <-levels(gi01$ITEM)






setwd("~/Desktop/Analysis/scaled")
p01<- read.delim("~/Desktop/Analysis/experiment/p01exp.txt")
sp01 <- read.delim("~/Desktop/Analysis/scaled/sp01.txt")
levels(p01$ITEM)


items <- levels(p01$ITEM)


#construct first half of data file (containing experiment information)
#select gesture blocks from experiment file
df <- p01[p01$BLOCK == "TRAIN1"|p01$BLOCK == "TRAIN2" |p01$BLOCK == "TEST1" |p01$BLOCK == "TEST2",]
df <- subset(df, select = c("PID", "TRIALNO", "BLOCK", "ITEM", "ICONIC","VERIDICAL","DUMMYIC","ENG"))
df
#iconicity ratings from experiment file
ic <- p01[p01$BLOCK == "RATING",]
ic <- subset(ic, select = c("ITEM", "IC_RATING"))
ic
#sort df by block then by item (alphabetically)
df <- df[order(df$BLOCK,df$ITEM),]
#sort ic alphabetically
ic <-ic[order(ic$ITEM),]
#add iconicity ratings to df
df$IC_RATING <- ic$IC_RATING
#iconicity ratings from vinson experiment
original_vinson <- read.delim("~/Desktop/Analysis/original_vinson.txt")
#all
vic_all <- subset(original_vinson, select = c("Label", "Icon_mean"))
vic_all
#iconicity ratings for the signs
vic_signs <-subset(vic_all, vic_all$Label %in% toupper(levels(df$ITEM)))
vic_signs
#iconicity ratings for the (dummy) english 
vic_dummy <-subset(vic_all, vic_all$Label %in% toupper(levels(df$ENG)))
vic_dummy
#add both vinson iconicity ratings to df
df$VS_IC <- vic_signs$Icon_mean
df$VE_IC <- vic_dummy$Icon_mean
df
df<-df[order(df$BLOCK, df$ITEM),]
df[,c("BLOCK","ITEM")]
df$BLOCK <-factor(df$BLOCK)


#start buliding dtw df
row = 1
df[row,"ITEM"]
df[row,"BLOCK"]

sp01 <- sp01[sp01$BLOCK == "TRAIN1"|sp01$BLOCK == "TRAIN2" |sp01$BLOCK == "TEST1" |sp01$BLOCK == "TEST2",]
sp01$BLOCK <- factor(sp01$BLOCK)

#get participant's gesture for row
pgesture <- sp01[sp01$BLOCK ==  df[row,"BLOCK"] & sp01$ITEM == df[row,"ITEM"], c("RSX", "RSY", "LSX", "LSY",
                                                                                 "REX", "REY", "LEX", "LEY",
                                                                                 "RWX", "RWY", "LWX", "LWY")]

pgesture
# get mirrored gesture:


pgesture_mirrored <- pgesture
colnames(pgesture)
colnames(pgesture_mirrored) <- NULL
colnames(pgesture_mirrored) <- c("LSX","LSY","RSX","RSY","LEX","LEY","REX","REY","LWX","LWY","RWX","RWY")
pgesture_mirrored <-pgesture_mirrored[,colnames(pgesture)]
pgesture_mirrored

head(pgesture)
head(pgesture_mirrored)


i_gesture1 <- gi01[gi01$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                           "REX", "REY", "LEX", "LEY",
                                                           "RWX", "RWY", "LWX", "LWY")]

i_gesture2 <- gi02[gi02$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                           "REX", "REY", "LEX", "LEY",
                                                           "RWX", "RWY", "LWX", "LWY")]

i_gesture3 <- gi03[gi03$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                           "REX", "REY", "LEX", "LEY",
                                                           "RWX", "RWY", "LWX", "LWY")]

i_gesture4 <- gi04[gi04$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                           "REX", "REY", "LEX", "LEY",
                                                           "RWX", "RWY", "LWX", "LWY")]


T_directDIST1 <- NA
T_directDIST1 <- dtw(pgesture, i_gesture1)$normalizedDistance

T_directDIST2 <-NA
T_directDIST2 <- dtw(pgesture, i_gesture2)$normalizedDistance

T_directDIST3 <-NA
T_directDIST3 <- dtw(pgesture, i_gesture3)$normalizedDistance

T_directDIST4 <-NA
T_directDIST4 <- dtw(pgesture, i_gesture4)$normalizedDistance


T_mirrorDIST1 <-NA
T_mirrorDIST1 <- dtw(pgesture_mirrored, i_gesture1)$normalizedDistance

T_mirrorDIST2 <- NA
T_mirrorDIST2 <- dtw(pgesture_mirrored, i_gesture2)$normalizedDistance

T_mirrorDIST3 <-NA
T_mirrorDIST3 <-dtw(pgesture_mirrored, i_gesture3)$normalizedDistance

T_mirrorDIST4 <-NA
T_mirrorDIST4 <-dtw(pgesture_mirrored,i_gesture4)$normalizedDistance

correctness <- NA
correctness <- head(sp01[sp01$BLOCK == df[row,"BLOCK"] & sp01$ITEM == df[row,"ITEM"], "CORRECT"],1)

Trow <- matrix(c(correctness, T_directDIST1,T_directDIST2,T_directDIST3,T_directDIST4, T_mirrorDIST1, T_mirrorDIST2, T_mirrorDIST3, T_mirrorDIST4),nrow = 1)
colnames(Trow) <- c("CORRECT","T_directdist1", "T_directdist2", "T_directdist3", "T_directdist4", "T_mirrordist1", "T_mirrordist2", "T_mirrordist3", "T_mirrordist4")

distances <- Trow
distances








#loop through remaining rows of dataframe getting distances

for(r in 2:nrow(df)) {
  
  
  row <- r
  df[row,"ITEM"]
  df[row,"BLOCK"]
  
  #get participant's gesture for row
  pgesture <- sp01[sp01$BLOCK ==  df[row,"BLOCK"] & sp01$ITEM == df[row,"ITEM"], c("RSX", "RSY", "LSX", "LSY",
                                                                                   "REX", "REY", "LEX", "LEY",
                                                                                   "RWX", "RWY", "LWX", "LWY")]
  
  pgesture_mirrored <- pgesture
  colnames(pgesture)
  colnames(pgesture_mirrored) <- NULL
  colnames(pgesture_mirrored) <- c("LSX","LSY","RSX","RSY","LEX","LEY","REX","REY","LWX","LWY","RWX","RWY")
  pgesture_mirrored <-pgesture_mirrored[,colnames(pgesture)]
  pgesture_mirrored
  
  head(pgesture)
  head(pgesture_mirrored)
  
  
  i_gesture1 <- gi01[gi01$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                             "REX", "REY", "LEX", "LEY",
                                                             "RWX", "RWY", "LWX", "LWY")]
  
  i_gesture2 <- gi02[gi02$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                             "REX", "REY", "LEX", "LEY",
                                                             "RWX", "RWY", "LWX", "LWY")]
  
  i_gesture3 <- gi03[gi03$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                             "REX", "REY", "LEX", "LEY",
                                                             "RWX", "RWY", "LWX", "LWY")]
  
  i_gesture4 <- gi04[gi04$ITEM == toupper(df[row,"ITEM"]), c("RSX", "RSY", "LSX", "LSY",
                                                             "REX", "REY", "LEX", "LEY",
                                                             "RWX", "RWY", "LWX", "LWY")]
  
  
  T_directDIST1 <- NA
  #tries to get dtw, but if it can't just throws an error without exiting the for-loop!!
  tryCatch({T_directDIST1 <- dtw(pgesture, i_gesture1)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  T_directDIST2 <-NA
  tryCatch({T_directDIST2 <- dtw(pgesture, i_gesture2)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  T_directDIST3 <-NA
  tryCatch({T_directDIST3 <- dtw(pgesture, i_gesture3)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  T_directDIST4 <-NA
  tryCatch({T_directDIST4 <- dtw(pgesture, i_gesture4)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  
  T_mirrorDIST1 <-NA
  tryCatch({T_mirrorDIST1 <- dtw(pgesture_mirrored, i_gesture1)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  T_mirrorDIST2 <- NA
  tryCatch({T_mirrorDIST2 <- dtw(pgesture_mirrored, i_gesture2)$normalizedDistance}, error =function(e){cat("oops:",conditionMessage(e), "\n")})
  
  T_mirrorDIST3 <-NA
  tryCatch({T_mirrorDIST3 <- dtw(pgesture_mirrored, i_gesture3)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  T_mirrorDIST4 <-NA
  tryCatch({T_mirrorDIST4 <- dtw(pgesture_mirrored, i_gesture4)$normalizedDistance}, error = function(e){cat("oops:",conditionMessage(e), "\n")})
  
  correctness <- NA
  tryCatch({ correctness <- head(sp01[sp01$BLOCK == df[row,"BLOCK"] & sp01$ITEM == df[row,"ITEM"], "CORRECT"],1)}, error = function(e){cat("Nope:",conditionMessage(e), "\n")})
  
  Trow <- matrix(c(correctness, T_directDIST1,T_directDIST2,T_directDIST3,T_directDIST4, T_mirrorDIST1, T_mirrorDIST2, T_mirrorDIST3, T_mirrorDIST4),nrow = 1)
  colnames(Trow) <- c("CORRECT","T_directdist1", "T_directdist2", "T_directdist3", "T_directdist4", "T_mirrordist1", "T_mirrordist2", "T_mirrordist3", "T_mirrordist4")
  
  distances <- rbind(distances,Trow)
}


distances

df <- cbind(df,distances)


dttp01 <-df
View(dttp01)




