# Load libraries
print("Loading libraries")
library(dplyr, warn.conflicts=F)
library(tidyr, warn.conflicts=F)
library(mgcv, warn.conflicts=F)
library(ggplot2, warn.conflicts=F)
library(reshape2, warn.conflicts=F)
# Read in the data
print("Reading in the data")
dh.data = tbl_df(read.csv('../data/dh-PNC.csv', header=T))

# Initialize data structures
models = list() # Fitted models
results = data.frame() # Features of models
values = data.frame() # Predicted contribution of smooth term

print("Fitting models for speakers")
for (s in unique(dh.data$speaker)) {
  this.data = dh.data %>% filter(speaker == s)
  mod0 = gam(obs ~ prev*log.lag, family="binomial", data = this.data)
  mod = gam(obs ~ s(time, bs='ts') + prev*log.lag, family="binomial", data = this.data) #, select=T)
  # Interpretation of coefficients
  # prev1:  when you say 'that' you're more likely to say 'that again
  # log(lag): decay back towards baseline after saying 'dat'
  # prev1:log(lag): priming decay and move back to baseline
  models[[s]] = list(mod0, mod) 
  # (1) Smooth function of time
  logit = plot.gam(mod)[[1]]$fit
  pred = 1/(1 + exp(logit))
  pred = pred - mean(pred)
  # Add s(time) values to data frame
  values.df = data.frame(speaker=rep(s,100),x=c(1:100),pred)
  values = rbind(values.df, values)
  # (2) Priming estimate
  priming = coef(mod)["prev"]
  # (3) delta AIC
  delta.AIC = mod0$aic - mod$aic
  # (4) Estimated degrees of freedom from s(time)
  edf = summary(mod)$edf
  # Add to results data frame
  results.df = data.frame(speaker=s, priming=priming, 
                          priming.p=1/(1+exp(priming)), 
                          delta.AIC=delta.AIC,
                          smooth.improve=(delta.AIC > 2), #as.numeric(delta.AIC > 2),
                          edf=edf,
                          n=nrow(this.data))
  results = rbind(results.df, results)
}

 Inspect the full model for each speaker and check diagnostics
 for (model in seq_along(models)) {
   print(model)
   #print(summary.gam(models[[model]])$edf)
   print(gam.check(models[[model]])$p.value)
   readline()
 }

results = tbl_df(results)

# We can see that
ggplot(results, aes(x=delta.AIC, y=priming, label=speaker)) + 
  geom_text()
ggplot(results, aes(x=n, y=priming, label=speaker)) + 
  geom_text()

# Filter speakers
results = results %>% filter(! speaker %in% c(7,11,13))
values = tbl_df(values) %>% filter(! speaker %in% c(7,11,13))

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

# 
ggplot(results, aes(x=priming)) + geom_density() + 
  geom_dotplot(binwidth=.1) +
  ylab("Probability density") + 
  xlab("Priming estimate (in logits)") + theme(text = element_text(size=20))
# ggsave()
# These logit priming estimates are normally distributed
shapiro.test(unique(results$priming))

# Join the 
mod.smooths = tbl_df(full_join(values, results, by="speaker"))

range = max(abs(mod.smooths$pred))
ggplot(mod.smooths, aes(x=x, y=pred, group=speaker, color=smooth.improve)) + 
  geom_line() +  # aes(alpha=(1 - edf/max(edf))*.8 + edf/max(edf))
  facet_wrap(~ smooth.improve) +
  xlab("Time (rescaled)") +
  ylab("Predicted probability (centered)") + 
  ylim(-range,range) + 
  theme(legend.position="none", text = element_text(size=20), strip.text = element_blank()) #  # Remove TRUE and FALSE labels
#ggsave(file='dynamic-style-LV.pdf')

ggplot(results, aes(x=edf)) +
  geom_density(aes(fill=smooth.improve, alpha=.5)) +
  geom_dotplot(aes(alpha=.5), binwidth=.25) + facet_wrap(~ smooth.improve) +
 xlab("Estimated degrees of freedom") + ylab("Probability density") +
 theme(legend.position="none", text = element_text(size=20), strip.text = element_blank())  # Remove TRUE and FALSE labels
#ggsave(file='edf-dynamic.pdf')

