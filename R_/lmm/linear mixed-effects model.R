### linear mixed-effects model

library(lme4)
library(lmerTest)

# upload data
dat <- read.delim("AWCD.txt", header = TRUE, row.names = 1)

dat$Period <- factor(dat$Period, levels = c("NGFD", "GFD"))
dat$Year   <- factor(dat$Year,   levels = c("2024", "2025"))
dat$Month  <- factor(dat$Month,
                     levels = c("Feb","Mar","Apr","May","Jun",
                                "Jul","Aug","Sep","Oct"))

# interaction terms

m_int <- lmer(AWCD ~ Period * Year + (1 | Month), data = dat)

summary(m_int)