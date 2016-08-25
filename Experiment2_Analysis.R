################
# MSc Dissertation (BSL iconicity)
# plots and analysis for experiment 2
################
library(ggplot2)
library(grid)
library(gridExtra)
library(lme4)
library(lmerTest)


############################
# no of correct responses  #
############################

p_learn <- read.delim("~/Desktop/Analysis/dataFiles/dist_target.txt")

test_rounds <- subset(p_learn, BLOCK == c("TEST1", "TEST2"))
levels(test_rounds$COMBINED) <- c("ARBITRARY\nFAKE", "ARBITRARY\nVERIDICAL", "ICONIC\nFAKE", "ICONIC\nVERIDICAL")

class(test_rounds$ICONIC)
test_rounds$ICONIC <-as.factor(test_rounds$ICONIC)
test_rounds$VERIDICAL <- as.factor(test_rounds$VERIDICAL)
# proportion of correct responses 
ggplot(test_rounds,aes(x=COMBINED,y=CORRECT))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+ylab("proportion correct")+xlab("") 

#iconicity ratings - participants more likely to remember things they rate as iconic
ggplot(na.omit(test_rounds), aes(y = IC_RATING, x = as.factor(CORRECT)))+geom_boxplot(fill = c("#5cd6d6"))+xlab(" ")+ylab("iconicity rating")+scale_x_discrete(labels = c("INCORRECT", "CORRECT"))

# predict correctness based on iconic/veridical 
p_learn_model <- glmer(CORRECT ~ ICONIC * VERIDICAL + (1|PID) + (1|ITEM), data = na.omit(test_rounds), family = 'binomial', control = glmerControl(optimizer = 'bobyqa'))
p_learn_null <-glmer(CORRECT ~ (1|PID) + (1|ITEM) + (1|ENG), data = na.omit(test_rounds), family = 'binomial', control = glmerControl(optimizer='bobyqa'))
summary(p_learn_model) #significant interaction
anova(p_learn_model, p_learn_null) #model improves over chance

#predict correctness with iconicity rating
p_learn_model2 <- glmer(CORRECT ~ IC_RATING + (1|PID) + (1|ITEM) + (1|ENG), data = na.omit(test_rounds), family = 'binomial',  control = glmerControl(optimizer='bobyqa'), REML = FALSE)
p_learn_null2 <-glmer(CORRECT ~ (1|PID) + (1|ITEM) + (1|ENG), data = na.omit(test_rounds),family = 'binomial',  control = glmerControl(optimizer='bobyqa'), REML = FALSE)
summary(p_learn_model2) #also not significant
anova(p_learn_model2,p_learn_null2)#significante


######################
# bounding box size  #
######################
bounding_box <- read.delim("~/Desktop/Analysis/dataFiles/bounding_box.txt")
bounding_box$ICONIC<- as.factor(bounding_box$ICONIC)
bounding_box$VERIDICAL <- as.factor(bounding_box$VERIDICAL)
head(bounding_box[,c("ICONIC", "VERIDICAL", "COMBINED")])
levels(bounding_box$COMBINED)
levels(bounding_box$COMBINED) <- c("ARBITRARY\nFAKE", "ARBITRARY\nVERIDICAL", "ICONIC\nFAKE", "ICONIC\nVERIDICAL")

test_box <- subset(bounding_box,BLOCK == c("TEST1", "TEST2"))
train_box <-subset(bounding_box, BLOCK == c("TRAIN1", "TRAIN2"))
#bounding box size
#ggplot(bounding_box,aes(x=COMBINED,y=bArea))+stat_summary(fun.y=mean,geom='bar', fill = c("#00cc99", "#008060", "#ffcc66", "#ffb31a"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("pixels ")

boxtest <- ggplot(test_box,aes(x=COMBINED,y=bArea))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("pixels ")+ggtitle("training trials")
boxtrain <-ggplot(train_box,aes(x=COMBINED,y=bArea))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("")+ggtitle("test trials")

grid.arrange(boxtest,boxtrain, nrow = 1)

##test_blocks only:
box_test_model <-lmer(bArea ~ICONIC*VERIDICAL + (1|PID) + (1|ITEM), data = test_box, REML = FALSE)
box_test_model_null <-lmer(bArea ~ (1|PID) + (1|ITEM), data = test_box, REML = FALSE)
summary(box_test_model) #ns
anova(box_test_model,box_test_model_null) #ns

box_test_model <-lmer(bArea ~ VERIDICAL + (1|PID) + (1|ITEM), data = test_box, REML = FALSE)

##train_blocks only:
box_train_model <-lmer(bArea ~ ICONIC*VERIDICAL + (1|PID) + (1|ITEM), data = train_box, REML = FALSE)
box_train_model_null <-lmer(bArea ~ (1|PID) + (1|ITEM), data = train_box, REML = FALSE)
summary(box_train_model) #ns
anova(box_train_model,box_train_model_null) #ns


######################
# gesture duration 
######################

duration_data <- read.delim("~/Desktop/Analysis/dataFiles/duration.txt")
duration_data$ICONIC <- as.factor(duration_data$ICONIC)
duration_data$VERIDICAL <- as.factor(duration_data$VERIDICAL)
levels(duration_data$COMBINED)
levels(duration_data$COMBINED) <- c("ARBITRARY\nFAKE", "ARBITRARY\nVERIDICAL", "ICONIC\nFAKE", "ICONIC\nVERIDICAL")


duration_test <-subset(duration_data,BLOCK == c("TEST1", "TEST2"))
duration_train <-subset(duration_data,BLOCK == c("TRAIN1", "TRAIN2"))


#duration
d_test <-ggplot(duration_test,aes(x=COMBINED,y=duration))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab(" ")+ggtitle("test trials")
d_train<-ggplot(duration_test,aes(x=COMBINED,y=duration))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab("frames ")+ylab(" ")+ggtitle("training trials")


d_test
d_train

#massive outlier due to some weird incorrect responses where people waved their arms around for ages
#massive outliers: 
#function to find outliers (from stats notes lab 6)
outliers <-function(obs, x = 2.5) {
  # get absolute distance from mean, check if it's bigger than x sd from mean.
  out <- obs- mean(obs, na.rm = T) > (x*sd(obs, na.rm = T))
  return(out)
}


which(outliers(duration_train$duration))  
mean(duration_train$duration,na.rm = TRUE)

#re-plotted with outliers removed: 

d_test <-ggplot(duration_test[-c(440,465,542),],aes(x=COMBINED,y=duration))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab("")+ylab("")+ggtitle("test trials")
d_train <-ggplot(duration_train[-c(118,293,339,373,830)],aes(x=COMBINED,y=duration))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab("")+ylab("frames")+ggtitle("training trials")
grid.arrange(d_train,d_test,nrow =1)
#model, excluding outliers 

duration_test_model <- lmer(duration~ ICONIC*VERIDICAL + (1|PID) + (1|ITEM), data = duration_test[-c(440,465,542),])
duration_test_null <- lmer(duration ~(1|PID) + (1|ITEM) + (1|ENG), data = duration_test[-c(440,465,542),])
summary(duration_test_model) #main effect of iconicity (increase 12 frames) and interaction iconicity*veridical - iconic signs last longer unless they are veridical?
anova(duration_test_model, duration_test_null) #model improves over chance


duration_train_model <- lmer(duration~ ICONIC*VERIDICAL + (1|PID) + (1|ITEM), data = duration_train[-c(118,293,339,373,830),])
duration_train_null <- lmer(duration ~(1|PID) + (1|ITEM) + (1|ENG), data = duration_train[-c(118,293,339,373,830),])
summary(duration_train_model) #main effect of iconicity (increase 12 frames) and interaction iconicity*veridical - iconic signs last longer unless they are veridical?
anova(duration_train_model, duration_train_null) #model improves over chance


plot(duration_model)
hist(residuals(duration_model)) #residuals not normally distributed
qqnorm(residuals(duration_model))
qqline(residuals(duration_model)) 



######################
# distance to target #
######################

dat <- read.delim("~/Desktop/Analysis/dataFiles/new_dist_target.txt")
dat$ICONIC <-as.factor(dat$ICONIC)
dat$VERIDICAL <- as.factor(dat$VERIDICAL)
levels(dat$COMBINED)

test_distances <-subset(dat,BLOCK == c("TEST1", "TEST2"))
train_distances <-subset(dat,BLOCK == c("TRAIN1", "TRAIN2"))

#plots

#sanity check - distances are larger for incorrect items :)
ggplot(na.omit(test_distances), aes(x = as.factor(CORRECT), y = SMALLEST))+stat_summary(fun.y=mean,geom='bar', fill = "#5cd6d6")+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width = .1)+xlab("")+ylab("normalised distance")+scale_x_discrete(labels = c("INCORRECT", "CORRECT"))
ggplot(na.omit(test_distances), aes(y = SMALLEST, x = as.factor(CORRECT)))+geom_boxplot(fill = "#5cd6d6")+xlab(" ")+ylab("distance")+scale_x_discrete(labels = c("INCORRECT", "CORRECT"))

#can report this :-)
dist_correct <- lmer(SMALLEST ~ as.factor(CORRECT) + (1|PID)+ (1|ITEM), data = test_distances, REML = FALSE)
dist_correct_null <- lmer(SMALLEST ~(1|PID) + (1|ITEM), data = test_distances, REML = FALSE)
summary(dist_correct)
anova(dist_correct, dist_correct_null)

#veridical pairings were produced more accurateley
ggplot(test_distances[test_distances$CORRECT == 1,],aes(x=COMBINED,y=SMALLEST))+stat_summary(fun.y=mean,geom='bar', fill = c("#00cc99", "#008060", "#ffcc66", "#ffb31a"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("normalised distance")
#without excluding incorrect. 

test_dist <-ggplot(test_distances,aes(x=COMBINED,y=SMALLEST))+stat_summary(fun.y=mean,geom='bar', fill = c("#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("")+ggtitle("test trials")
train_dist <-ggplot(train_distances,aes(x=COMBINED,y=SMALLEST))+stat_summary(fun.y=mean,geom='bar', fill = c( "#008060","#00cc99", "#ffb31a","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("normalised distance")+ggtitle("training trials")

grid.arrange(train_dist,test_dist,nrow = 1)

#veridical items are easier to learn. Fake iconic items are especially difficult
test_dist_m <-lmer(SMALLEST~ICONIC*VERIDICAL +(1|PID)+ (1|ITEM), data = test_distances, REML = FALSE)
#model comparison to the model without thei nteraction
dist_null <-lmer(SMALLEST~ICONIC + (1|PID)+(1|ITEM), data = test_distances,REML = FALSE)
summary(test_dist_m)
anova(test_dist_m,dist_null) #

#veridical items easier to copy
train_dist_m <-lmer(SMALLEST~ ICONIC*VERIDICAL +(1|PID)+ (1|ITEM), data = train_distances, REML = FALSE)
train_null <- lmer(SMALLEST ~ (1|PID)+ (1|ITEM), data = train_distances, REML = FALSE)
summary(train_dist_m)
anova(train_dist_m,train_null)

plot(dist_model)
hist(residuals(dist_model)) 
qqnorm(residuals(dist_model))
qqline(residuals(dist_model)) 


##########
# mirroring
##########

mirror <- read.delim("~/Desktop/Analysis/dataFiles/new_dist_target.txt")

mirror$MIRRORED <- ifelse(mirror$MIRRORED == TRUE,1,0)
colnames(mirror)
levels(mirror$COMBINED) <- c("ARBITRARY\nFAKE", "ARBITRARY\nVERIDICAL", "ICONIC\nFAKE", "ICONIC\nVERIDICAL")
head(mirror[,c("ICONIC", "VERIDICAL", "COMBINED")])
train_mirror <-subset(mirror, BLOCK == c("TRAIN1", "TRAIN2"))
test_mirror <-subset(mirror, BLOCK == c("TEST1", "TEST2"))

mirror_train <- ggplot(train_mirror, aes(x =COMBINED,y =MIRRORED))+stat_summary(fun.y = mean, geom = 'bar', fill = c("#008060","#00cc99", "#ffb31a","#ffcc66"))+ggtitle("training trials")+ylab("proportion mirrored")+xlab("")+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)
mirror_test <- ggplot(test_mirror, aes(x =COMBINED,y =MIRRORED))+stat_summary(fun.y = mean, geom = 'bar', fill =c("#008060","#00cc99", "#ffb31a","#ffcc66"))+ggtitle("test trials")+ylab(" ")+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab("")
mirror_train

grid.arrange(mirror_train,mirror_test, nrow = 1)

mirror_train_model <-glmer(MIRRORED ~ ICONIC*VERIDICAL + (1|PID) + (1|ITEM), data = train_mirror)
null_mirror_train <-glmer(MIRRORED ~ICONIC + VERIDICAL +(1|PID) + (1|ITEM), data = train_mirror)
summary(mirror_train_model)
anova(mirror_train_model,null_mirror_train)



mirror_test_model <-glmer(MIRRORED ~ ICONIC*VERIDICAL + (1|PID) + (1|ITEM), data = test_mirror)
null_mirror_test <-glmer(MIRRORED ~(1|PID) + (1|ITEM), data = test_mirror)
summary(mirror_test_model)
anova(mirror_test_model,null_mirror_test)


