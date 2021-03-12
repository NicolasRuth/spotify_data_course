install.packages("tidyverse") # Installiert tidyverse (Eine Sammlung vieler
                              # nützlicher packages für Datenaufbereitung, Grafikgestaltung etc.)

library(tidyverse) # Lädt tidyverse
library(ggplot2)

spotify_data <- read.csv("./data/charts.csv") # lädt die Datei in einen Datensatz

# Datensatz inspizieren

head(spotify_data)

str(spotify_data)

table(spotify_data$genre1)

qplot(spotify_data$tempo) # tidyverse

hist(spotify_data$energy) # base R

qplot(spotify_data$valence, geom = "density")

# Erste graphische Analysen

qplot(as.factor(year), duration_ms/1000,
      data = spotify_data,
      color = as.factor(year))

qplot(explicit,
      data = spotify_data,
      geom = "bar",
      color = as.factor(explicit))

qplot(as.factor(year), loudness,
      data = spotify_data,
      geom = "boxplot",
      color = as.factor(year))

qplot(popularity, danceability,
      data = spotify_data)

qplot(popularity, danceability,
      data = spotify_data,
      geom = c("point", "smooth"),
      method = "lm")

qplot(speechiness, genre1,
      data = spotify_data,
      geom = c("boxplot"),
      color = as.factor(year))
