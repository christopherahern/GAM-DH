# Load libraries
print("Loading libraries")
library(dplyr, warn.conflicts=F)
library(tidyr, warn.conflicts=F)
library(mgcv, warn.conflicts=F)
library(ggplot2, warn.conflicts=F)
library(reshape2, warn.conflicts=F)
# Read in the data
print("Reading in the data")
dh.data = tbl_df(read.csv('data/dh-PNC.csv', header=T))
#dh.data$obs = as.factor(dh.data$obs)
dh.data$prev = as.factor(dh.data$prev)
dh.data$log.lag = log(dh.data$Lag)
dh.data$time = dh.data$Seg_Start
# Initialize data structures
models = list() # Fitted models
results = data.frame() # Features of models
values = data.frame() # Predicted contribution of smooth term
# Fit the models for each speaker
print("Fitting models for speakers")
for (s in unique(dh.data$speaker)) {
  this.data = dh.data %>% filter(speaker == s)
  mod0 = gam(obs ~ prev*log.lag, family="binomial", data = this.data)
  mod = gam(obs ~ s(time) + prev*log.lag, family="binomial", data = this.data) #, select=T)
  # Interpretation of coefficients
  # prev1:  when you say 'that' you're more likely to say 'that again
  # log(lag): decay back towards baseline after saying 'dat'
  # prev1:log(lag): priming decay and move back to baseline
  models[[s]] = list(mod0, mod) 
  # (1) Smooth function of time
  logit = plot.gam(mod)[[1]]$fit
  pred = plogis(logit)
  pred = pred - mean(pred)
  # Add s(time) values to data frame
  values.df = data.frame(speaker=rep(s,100),x=c(1:100),pred)
  values = rbind(values.df, values)
  # (2) Priming estimate
  priming = coef(mod)["prev1"]
  # (3) delta AIC
  delta.AIC = mod0$aic - mod$aic
  # (4) Estimated degrees of freedom from s(time)
  edf = summary(mod)$edf
  # Add to results data frame
  results.df = data.frame(speaker=s, priming=priming, 
                          priming.p=plogis(priming), 
                          delta.AIC=delta.AIC,
                          smooth.improve=(delta.AIC > 2),
                          edf=edf,
                          n=nrow(this.data))
  results = rbind(results.df, results)
}

# Write results to local output
write.csv(results, 'local/results.csv', row.names=F)

# Plot the predicted probabilities of use for a given speaker
this.data = dh.data %>% filter(speaker == 16)
this.data$predicted = predict(models[[16]][[2]], type="response")
ggplot(this.data, aes(x=time, y=predicted, color=prev)) +
  geom_point(size = 4,alpha=.4) +
  coord_cartesian(ylim = c(0, 1)) +
  ylab("Predicted probability") +
  xlab("Time") + theme(text = element_text(size=20))
ggsave(file='local/style-speaker-LV.pdf', width=10)


# Inspect the full model for each speaker and check diagnostics
# for (model in seq_along(models)) {
#   print(model)
#   #print(summary.gam(models[[model]])$edf)
#   print(gam.check(models[[model]])$p.value)
#   readline()
# }

# Convert the results data frame and create local output directory
results = tbl_df(results)
dir.create('local/', mode="0777", showWarnings=FALSE)
# Filter outliers that are visually apparent
ggplot(results, aes(x=delta.AIC, y=priming, label=speaker)) + 
  geom_text()
ggplot(results, aes(x=n, y=priming, label=speaker)) + 
  geom_text()
# We can use being three times distant from the interquartile range
q = quantile(results$priming)
lower = q[2] - 3*(q[4] - q[2]) 
upper = q[4] + 3*(q[4] - q[2])
results = results %>% filter(lower < priming, priming  < upper)
values = tbl_df(values)  %>% filter(speaker %in% unique(results$speaker))


# Plot the relationships between various measures
# Can we only detect model improvement for speakers with lots of data?
ggplot(results, aes(x=delta.AIC, y=n, label=speaker)) + 
  geom_text() + geom_smooth(method='lm', se=F)
cor.test(results$delta.AIC, results$n)
  # Seeing an improvement in the model fit is not linearly correlated
  # with the number of data points for the speaker

# Does detecting model improvement change results for priming?
ggplot(results, aes(x=delta.AIC, y=priming, label=speaker)) + 
  geom_text() + geom_smooth(method='lm', se=F)
cor.test(results$delta.AIC, results$priming)
  # Seeing an improvement in the model is not linearly correlated
  # with the size of the priming coefficient

# Is our estimate of priming affected by the amount of data?
ggplot(results, aes(x=priming, y=n, label=speaker)) + 
  geom_text() + geom_smooth(method='lm', se=F)
cor.test(results$priming, results$n)
  # The priming coefficient estimates are not linearly correlated
  # with the number of data points for the speaker

# Do model improvements correspond to higher estimated degrees of freedom?
ggplot(results, aes(x=edf, y=delta.AIC, label=speaker)) + 
  geom_text() + geom_smooth(method='lm', se=F) + geom_hline(yintercept=2)
cor.test(results$edf, results$delta.AIC)
  # The estimated degrees of freedom are linearly correlated with the
  # improvement in the full model

# Plot the priming estimates 
ggplot(results, aes(x=priming)) + geom_density() + 
  geom_dotplot(binwidth=.1) +
  ylab("Probability density") + 
  xlab("Priming estimate (in logits)") + theme(text = element_text(size=20))
ggsave(file="local/priming-density-LV.pdf", width=10)
# These logit priming estimates are normally distributed
shapiro.test(unique(results$priming))

# Join the data into a single data frame 
mod.smooths = tbl_df(full_join(values, results, by="speaker"))

range = max(abs(mod.smooths$pred))
ggplot(mod.smooths, aes(x=x, y=pred, group=speaker, color=smooth.improve)) + 
  geom_line() +  
  facet_wrap(~ smooth.improve) +
  xlab("Time (rescaled)") +
  ylab("Predicted probability (centered)") + 
  ylim(-range,range) + 
  theme(legend.position="none", text = element_text(size=20), strip.text = element_blank())  
ggsave(file='local/dynamic-style-LV.pdf', width=10)

ggplot(results, aes(x=edf)) +
  geom_density(aes(fill=smooth.improve, alpha=.5)) +
  geom_dotplot(aes(alpha=.5), binwidth=.25) + facet_wrap(~ smooth.improve) +
 xlab("Estimated degrees of freedom") + ylab("Probability density") +
 theme(legend.position="none", text = element_text(size=20), strip.text = element_blank()) 
ggsave(file='local/edf-dynamic-LV.pdf', width=10)

