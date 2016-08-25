
#################################
##  informant bounding boxes   ##
#################################
iData <- read.delim("~/Desktop/Analysis/informant/iData.txt")
wristXY <- subset(iData,select = c("pID", "ITEM","ICONIC", "RWX", "LWX", "RWY", "LWY"))

#get max and min X positions of right and left wrists
wristXY$rxMax <- ave(wristXY$RWX, wristXY$pID, wristXY$ITEM, FUN = max)
wristXY$rxMin <- ave(wristXY$RWX, wristXY$pID, wristXY$ITEM, FUN = min)
wristXY$lxMax <- ave(wristXY$LWX, wristXY$pID, wristXY$ITEM, FUN = max)
wristXY$lxMin <- ave(wristXY$LWX, wristXY$pID, wristXY$ITEM, FUN = min)
#get max and min Y positions of right and left wrists
wristXY$ryMax <- ave(wristXY$RWY, wristXY$pID, wristXY$ITEM, FUN = max)
wristXY$ryMin <- ave(wristXY$RWY, wristXY$pID, wristXY$ITEM, FUN = min)
wristXY$lyMax <- ave(wristXY$LWY, wristXY$pID, wristXY$ITEM, FUN = max)
wristXY$lyMin <- ave(wristXY$LWY, wristXY$pID, wristXY$ITEM, FUN = min)

#Get max and min X positions of either wrist
wristXY$xMax <- pmax(wristXY$rxMax, wristXY$lxMax)
wristXY$xMin <- pmin(wristXY$rxMin, wristXY$lxMin)
wristXY$yMax <- pmax(wristXY$ryMax, wristXY$lyMax)
wristXY$yMin <- pmin(wristXY$ryMin, wristXY$lyMin)

#new dataframe with first row of wristsXY split by block and item (in order to have 1 row per gesture with min and max values)
#(discards all frames)
informantXY <- aggregate.data.frame(wristXY,list(wristXY$pID,wristXY$ITEM),head,1) #gets first row of dataframe split by pID and ITEM
informantXY <- subset(informantXY, select = c("pID", "ITEM","ICONIC", "rxMax", "rxMin", "lxMax", "lxMin", "ryMax", "ryMin", "xMax", "xMin", "yMax", "yMin"))

#bounding box height, width, area

informantXY$bWidth <- informantXY$xMax-informantXY$xMin
informantXY$bHeight <- informantXY$yMax-informantXY$yMin
informantXY$bArea <- informantXY$bWidth*informantXY$bHeight
#get mean bounding box area for each gesture


write.table(informantXY, file = "ibDat.txt", quote = FALSE, row.names = FALSE, sep = "\t")




informantXY <- aggregate(formula = bArea~ITEM, data = informantXY, FUN = mean)

informantXY


#################################
##  participant bounding boxes ##
#################################

p19 <- read.delim("~/Desktop/Analysis/experiment/p19exp.txt")
sp19 <- read.delim("~/Desktop/Analysis/scaled/sp19.txt")
#select gesture blocks from experiment file
df <- p19[p19$BLOCK == "TRAIN1"|p19$BLOCK == "TRAIN2" |p19$BLOCK == "TEST1" |p19$BLOCK == "TEST2",]
df <- subset(df, select = c("PID", "TRIALNO", "BLOCK", "ITEM", "ICONIC","VERIDICAL","DUMMYIC","ENG"))
df
#iconicity ratings from experiment file
ic <- p19[p19$BLOCK == "RATING",]
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
#informant's mean bounding boxes for items
ibb <- informantXY[informantXY$ITEM %in% toupper(levels(df$ITEM)), ]
ibb
df$iBB <- ibb$bArea
df
#get wristX
wristXY <- subset(sp19,select = c("BLOCK", "ITEM", "RWX", "LWX", "RWY", "LWY"))
#get max and min X positions of right and left wrists 
wristXY$rxMax <- ave(wristXY$RWX, wristXY$BLOCK, wristXY$ITEM, FUN = max)
wristXY$rxMin <- ave(wristXY$RWX, wristXY$BLOCK, wristXY$ITEM, FUN = min)
wristXY$lxMax <- ave(wristXY$LWX, wristXY$BLOCK, wristXY$ITEM, FUN = max)
wristXY$lxMin <- ave(wristXY$LWX, wristXY$BLOCK, wristXY$ITEM, FUN = min)
#get max and min Y positions of right and left wrists
wristXY$ryMax <- ave(wristXY$RWY, wristXY$BLOCK, wristXY$ITEM, FUN = max)
wristXY$ryMin <- ave(wristXY$RWY, wristXY$BLOCK, wristXY$ITEM, FUN = min)
wristXY$lyMax <- ave(wristXY$LWY, wristXY$BLOCK, wristXY$ITEM, FUN = max)
wristXY$lyMin <- ave(wristXY$LWY, wristXY$BLOCK, wristXY$ITEM, FUN = min)
#Get max and min X positions of either wrist
wristXY$xMax <- pmax(wristXY$rxMax, wristXY$lxMax)
wristXY$xMin <- pmin(wristXY$rxMin, wristXY$lxMin)
wristXY$yMax <- pmax(wristXY$ryMax, wristXY$lyMax)
wristXY$yMin <- pmin(wristXY$ryMin, wristXY$lyMin)
#new dataframe with first row of wristsXY split by block and item (in order to have 1 row per gesture with min and max values)
#(discards all frames)
xy <- aggregate.data.frame(wristXY,list(wristXY$BLOCK,wristXY$ITEM),head,1) #gets first row of dataframe split by BLOCK and ITEM
xy <- subset(xy, select = c("BLOCK", "ITEM", "rxMax", "rxMin", "lxMax", "lxMin", "ryMax", "ryMin", "xMax", "xMin", "yMax", "yMin"))
#order df in order to be able to bind columns 
df <- df[order(df$ITEM, df$BLOCK),]

head(df) 
head(xy) #checkthe rows align properly (they do)



#add xy cols to df
df <- cbind(df,xy[3:12])
#bounding box height, width, area
df$bWidth <- df$xMax-df$xMin
df$bHeight <- df$yMax-df$yMin
df$bArea <- df$bWidth*df$bHeight
df$bbDiff <- df$bArea-df$iBB# bounding box difference to target 
bbp19<- df




setwd("~/Desktop/Analysis")
write.table(bounding_box, "bounding_box.txt", quote = FALSE, row.names = FALSE, sep = "\t")

write.table(dat, "dist_target.txt", quote = FALSE, row.names = FALSE, sep = "\t")



