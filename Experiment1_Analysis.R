################
# plots and analysis for experiment 1 (informant)
################
library(ggplot2)
library(lme4)
library(lmerTest)


###################
#bounding box size#
###################

#informant bounding boxes
i_bounding_box <- read.delim("~/Desktop/Analysis/dataFiles/i_bounding_box.txt")

#plot
ggplot(i_bounding_box,aes(x=as.factor(ICONIC),y=bArea))+stat_summary(fun.y=mean,geom='bar', fill =c("#00cc99","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+geom_jitter()+xlab(" ")+ylab("pixels")+scale_x_discrete(labels=c("ARBITRARY", "ICONIC"))

#model
ibox_model <- lmer(bArea~ as.factor(ICONIC) + (1|ITEM), data = i_bounding_box, REML = FALSE)
ibox_null <-lmer(bArea~ (1|ITEM), data = i_bounding_box, REML = FALSE)
summary(ibox_model) #ns
anova(ibox_model,ibox_null) #ns
#check residuals they look fine? 
plot(ibox_model, main ='informant bounding box')
qqnorm(residuals(ibox_model),main ='informant bounding box')
qqline(residuals(ibox_model),main ='informant bounding box')



###################
#   duration      #
###################

i_duration <- read.delim("~/Desktop/Analysis/dataFiles/i_duration.txt")

#plot
theme_set(theme_gray(base_size = 20))
ggplot(i_duration,aes(x=as.factor(ICONIC),y=duration))+stat_summary(fun.y=mean,geom='bar', fill =c("#00cc99","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("frames")+scale_x_discrete(labels=c("ARBITRARY", "ICONIC"))

#predict duration with fixed effect of iconicity, random effect of item. 
idur_model <- lmer(duration~ as.factor(ICONIC) + (1|ITEM), data = i_duration, REML = FALSE)
idur_null <-lmer(duration ~ (1|ITEM), data = i_duration, REML = FALSE)
summary(idur_model) #main effect of iconicity 
anova(idur_model,idur_null) #model significantly improves over chance 
#residuals look fine
plot(idur_model, main = 'informant duration') #no violation of heteroscedasticity
qqnorm(residuals(idur_model),main = 'informant duration')
qqline(residuals(idur_model),main = 'informant duration')



###################
# variability 
###################

#is distance to target smaller in training than in testing?? 
#interaction between closenes sto target in training - interaction with veridicalness? (block type)
#entering block type as a fixed effect. 

i_distances <- read.delim("~/Desktop/Analysis/dataFiles/i_dist.txt")
i_distances

ggplot(i_distances,aes(x=as.factor(ICONIC),y=mean_DTW))+stat_summary(fun.y=mean,geom='bar', fill =c("#00cc99","#ffcc66"))+stat_summary(fun.data=mean_cl_boot,geom='errorbar',width=0.1)+xlab(" ")+ylab("normalised distance")+scale_x_discrete(labels=c("ARBITRARY", "ICONIC"))

idist_model <- lm(mean_DTW~ as.factor(ICONIC) , data = i_distances)
summary(idist_model)


mean(i_distances$mean_DTW[i_distances$ICONIC == 0])



plot(idist_model, main ="informant distances") #violation of heteroscedasticity? 



#function to find outliers (from stats notes lab 6)
outliers <-function(obs, x = 2) {
  # get absolute distance from mean, check if it's bigger than x sd from mean.
  out <- abs(obs- mean(obs, na.rm = T)) > (x*sd(obs, na.rm = T))
  return(out)
}

which(outliers(i_distances$MEAN_DIST_TO_OTHERS)) #97,98,99,100
i_distances[c(97,98,99,100),] #Outlier: RHINO - because one of them is produced with 2 hands. 


