# Henry J Schmale
# graph-pm.R
#
# Graphs the Plus/Minus stats using data cleaned with get-pm-stats.py
# Assumes that datafile is named pmstats.csv, and is in current
# working directory

library(reshape2)
library(ggplot2)
library(data.table)
library(plyr)

pmstats <- as.data.table(read.csv('pmstats.csv'))
pmstats <- pmstats[order(date)]
pmstats$delta <- pmstats$ins - pmstats$del
pmstats$del <- pmstats$del * -1

df <- melt(as.data.frame(pmstats))
df$date <- as.Date(df$date)

ggplot(df, aes(x=date, y=value, color=variable)) +
  geom_area(aes(fill=variable),
            data = subset(df, variable %in% c('del', 'ins'))) +
  geom_line(aes(x=date, y=value),
           data = subset(df, variable == 'delta'))

