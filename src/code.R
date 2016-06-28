# Load libraries
print("Loading libraries")
library(dplyr, warn.conflicts=F)
library(mgcv, warn.conflicts=F)
library(ggplot2, warn.conflicts=F)
########################################################
# Read in the data
print("Reading in the data")
dh.data = tbl_df(read.csv('data/dh-PNC.csv', header=T))
dh.data$obs = as.factor(dh.data$obs)
dh.data$speaker = as.factor(dh.data$speaker)
dh.data$prev = as.factor(dh.data$prev)
dh.data$log.lag = log(dh.data$Lag)
dh.data$time = dh.data$Seg_Start
#######################################################
# List to hold models for individual speakers
models = list()
# Fit models with and without s(time) for each speaker
print("Fitting GAMs to individual speakers")
for (s in unique(dh.data$speaker)) {
  this.data = dh.data %>% filter(speaker == s)
  # Model with only interaction term
  mod0 = gam(obs ~ prev*log.lag, family="binomial", data = this.data)
  # Model with smooth function of time, can be penalized  out of the model by select = TRUE
  mod = gam(obs ~ s(time) + prev*log.lag, select = TRUE, family="binomial", data = this.data)
  models[[s]] = list(mod0, mod)
}
# Plot the predicted probabilities of use for a given speaker
print("Plotting results for individual speaker")
s = 22
this.data = dh.data %>% filter(speaker == s)
this.model = models[[s]][[2]]
this.data$predicted = predict(this.model, type="response")
this.smooth = data.frame(time = seq(0, max(this.data$time), length.out=100),
			smooth = plogis(this.model$coefficients[1] + .5*this.model$coefficients[2] + plot.gam(this.model)[[1]]$fit))
# Plot individual speaker
ggplot(this.smooth, aes(x=time, y=smooth)) +
  geom_line() +
  coord_cartesian(xlim = c(-5, 3005), ylim = c(0, 1)) +
  scale_color_manual("Previous\ntoken",labels = c("stop (\"dis\")", "fricative (\"this\")"), values = c("#f03b20", "#a6bddb")) +
  ylab("Predicted probability of fricative (\"this\")") +
  xlab("Time") + theme(text = element_text(size=20)) + theme_bw() +
  geom_point(data = this.data, aes(x=time, y=predicted, color=prev), size = 4, alpha = .4)
ggsave("local/speaker-LV.pdf", width = 7, height = 5)
# Fit the model to all data
print('Fitting GAMM to all speaker data') # Add estimate of time
mod = bam(obs ~ prev*log.lag + s(prev, speaker, bs='re') +
		s(speaker, bs='re') + s(time, by=speaker, bs="fs", m=1) +
		post.pause + gender, data = dh.data, family='binomial')
#mod = bam(obs ~ prev*log.lag + PreSeg2 + sex + s(prev, speaker, bs='re') + s(speaker, bs='re') +  s(time, by=speaker, bs="fs", m=1),  data = dh.data, family='binomial')
# Extract plot data from GAM
print('Extracting plot data')
plot.data = plot.gam(mod, rug=FALSE)
index.offset = 2 # NOTE: Changes depending on the position of the random smooth argument, check plot.gam(mod)[[i]]
smooth.df = as.data.frame(summary(mod)$s.table[c((1 + index.offset):(42 + index.offset)),])
smooth.df$p.value = smooth.df$'p-value'
x.values = plot.data[[(1 + index.offset)]]$x 
x.length = length(x.values)
random.smooths = data.frame()
for (i in c(1:42)) {
	random.smooth = cbind(rep(i, x.length), 
				x.values, plot.data[[(i + index.offset)]]$fit, 
				rep(smooth.df$p.value[i], x.length), 
				rep(smooth.df$edf[i], x.length))
	random.smooths = rbind(random.smooth, random.smooths)
}
colnames(random.smooths) = c('speaker', 'time', 'smooth', 'smooth.p', 'edf')
# Plot random smooths by speaker
print('Plotting random smooths by speaker')
ggplot(random.smooths, aes(x=time, y=smooth, group=speaker)) +
        geom_line(aes(color=edf, size=edf), alpha = .8) + scale_size(range = c(1, 4), trans = 'exp') + 
        scale_color_gradient(low = 'white', high ='#f03b20') +
        coord_cartesian(xlim = c(-5, 5005), ylim = c(-1.25, 1.25)) +
        xlab("Time") +
        ylab("Random smooth by speaker (centered)") +
        theme_bw() + theme(legend.position="none", text = element_text(size=20)) +
	geom_hline(yintercept=0)
ggsave('local/gamm-smooths-LV.pdf', width = 10)
# Plot p-values by estimated degrees of freedom
print("Plotting estimated degrees of freedom")
ggplot(smooth.df, aes(x=edf, y=p.value, color = 'f03b20')) +
	geom_point() +
	coord_cartesian(xlim = c(0, 4)) +
        xlab("Estimated degrees of freedom") +
        ylab("P-value") +
        theme_bw() +
        theme(legend.position="none", text = element_text(size=20), strip.text = element_blank())
ggsave('local/edf-p-LV.pdf')

print(summary(mod))
