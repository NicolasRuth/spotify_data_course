install.packages("tidyverse") # Installiert tidyverse (Eine Sammlung vieler
                              # nützlicher packages für Datenaufbereitung, Grafikgestaltung etc.)

library(tidyverse) # Lädt tidyverse

spotify_data <- read_csv("./data/top10s.csv")[,2:15] # lädt die Datei in einen Datensatz

# This data comes from kaggle.com, it is called Top Spotify songs from 2010-2019
# - BY YEAR, uploaded by Leonardo Henrique - thanks!

names(spotify_data)[names(spotify_data) == "top genre"] <- "genre"

# Datensatz inspizieren

head(spotify_data)

str(spotify_data)

table(spotify_data$genre)

qplot(spotify_data$bpm) # tidyverse

hist(spotify_data$nrgy) # base R

qplot(spotify_data$val, geom = "density")

# erste graphische Analysen

qplot(as.factor(year), dur,
      data = spotify_data,
      color = as.factor(year))

qplot(as.factor(year), dB,
      data = spotify_data,
      geom = "boxplot",
      color = as.factor(year))

qplot(pop, dnce,
      data = spotify_data)

qplot(pop, dnce,
      data = spotify_data,
      color = as.factor(year))

qplot(pop, dnce,
      data = spotify_data,
      geom = c("point", "smooth"),
      method = "lm")
