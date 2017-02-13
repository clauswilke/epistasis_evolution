require(readr)  # for read_csv()
require(dplyr)  # for mutate()
require(tidyr)  # for unnest()
require(purrr)  # for map(), reduce()
require(cowplot)

#####
# Simulation data


# find all file names ending in .txt
files <- dir(pattern = "*.txt")

data <- files %>%
  map(read_tsv) %>%    # read in all the files individually, using 
  # the function read_csv() from the readr package
  reduce(rbind) %>%    # reduce with rbind into one dataframe
  filter(N==100)


#####
# Analytic result

Feq <- function(N, L, q){(1.-1./(2*N-1))^(L/q)}
data <- mutate(data, analytic=Feq(N, L, q))

#####
# Plot

p <- ggplot(data, aes(x=N*mu, y=mean, color=factor(q), shape=factor(q))) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)), 
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)), 
               geom = "pointrange",
               size=0.4) +
  geom_hline(aes(yintercept=analytic, color=factor(q))) +
  scale_x_log10() +
  ylab("mean fitness") +
  xlab("scaled mutation rate N*mu") +
  guides(color = guide_legend("Epistasis factor q"),
         shape = guide_legend("Epistasis factor q"))
p
save_plot("fitness_vs_Nmu.pdf", p, base_aspect_ratio = 1.5)

p2 <- p + facet_wrap(~factor(q))
save_plot("fitness_vs_Nmu_v2.pdf", p2, base_aspect_ratio = 3)
