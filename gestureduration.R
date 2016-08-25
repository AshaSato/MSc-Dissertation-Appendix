#################################
##  informant gesture duration ##
#################################

iData <- read.delim("~/Desktop/Analysis/informant/iData.txt")


iDur <- subset(iData, select = c("pID", "FRAME", "ITEM", "ICONIC"))

#get first and last frame for each gesture

iDur$min <- ave(iDur$FRAME, iDur$pID, iDur$ITEM, FUN = min)
iDur$max <- ave(iDur$FRAME, iDur$pID, iDur$ITEM, FUN = max)
iDur$duration <- iDur$max-iDur$min

#fix mistake in coding of saturday! 
iDur[iDur$ITEM == 'SATURDAY',"ICONIC"] <- 0

ggplot(iDur,aes(x=as.factor(ICONIC),y=duration))+stat_summary(fun.y=mean,geom='bar')+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)
ggplot(iDur,aes(x=as.factor(ITEM),y=duration, fill = as.factor(ICONIC)))+stat_summary(fun.y=mean,geom='bar')+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+theme(axis.text.x = element_text(angle = 90, hjust = 1))

t.test(iDur$ICONIC == 1, iDur$ICONIC == 0)


write.table(iDur, "i_duration.txt", quote = FALSE, row.names = FALSE, sep = "\t")


mean_ID <- aggregate(formula = duration~ITEM, data = iDur, FUN = mean )
mean_ID

iDur
items <- levels(iDur$ITEM)


iDur <- aggregate(formula = duration ~pID+ITEM, data = i_duration, FUN = mean)

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

iDur$ICONIC <- ifelse(iDur$ITEM %in% toupper(iconic), 1,0)

iDur


#################################
##  participant duration       ##
#################################

p37 <- read.delim("~/Desktop/Analysis/experiment/p37exp.txt")
sp37 <- read.delim("~/Desktop/Analysis/scaled/sp37.txt")
#select gesture blocks from experiment file
df <- p37[p37$BLOCK == "TRAIN1"|p37$BLOCK == "TRAIN2" |p37$BLOCK == "TEST1" |p37$BLOCK == "TEST2",]
df <- subset(df, select = c("PID", "TRIALNO", "BLOCK", "ITEM", "ICONIC","VERIDICAL","DUMMYIC","ENG"))
df

#iconicity ratings from experiment file
ic <- p37[p37$BLOCK == "RATING",]
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

#add informant mean duration for each item to df
id <- mean_ID[mean_ID$ITEM %in% toupper(df$ITEM),]
id
df$idur <- id$duration

#get duration (in frames)
pd <- subset(sp37, select = c("pID", "FRAME","BLOCK", "ITEM", "HESITATION"))
pd$min <- ave(sp37$FRAME, sp37$BLOCK, sp37$ITEM, FUN = min)
pd$max <- ave(sp37$FRAME, sp37$BLOCK, sp37$ITEM, FUN = max)
pd$duration <- pd$max-pd$min

pd <- aggregate.data.frame(pd$duration,list(pd$BLOCK,pd$ITEM,pd$HESITATION),head,1) #gets first row of dataframe split by BLOCK and ITEM
pd
pd <-pd[order(pd$Group.2,pd$Group.1),]


df <- df[order(df$ITEM),]
df

# if the following line doesn't work it's because there are missing items in the duration file
# the missing items for each participant are in block of code below - run the relevant block before continuing
#

df$hesitation <- pd$Group.3
df$duration <- pd$x

df$dDiff <- df$duration - df$idur

dp37 <-df
dp37




dData <- rbind(dp01,dp02,dp03,dp04,dp06,dp07,dp08,dp09,dp10,dp11,dp12,dp13,dp14,dp15,dp16,dp17,dp18,dp19,dp20,dp21,dp22,dp23,dp24,dp25,dp26,dp27,dp28,dp29,dp30,dp31,dp32,dp33,dp34,dp35,dp36,dp37)
levels(dData$PID)
setwd(setwd("~/Desktop/Analysis"))

write.table(mean_ID, "idData.txt", quote = FALSE, row.names = FALSE, sep = "\t")





