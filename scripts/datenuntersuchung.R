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

# Die einzelnen Audio Features von Spotify sind hier beschrieben:
# https://developer.spotify.com/documentation/web-api/reference/#endpoint-get-audio-features

# Erste grafische Analysen

qplot(as.factor(year), duration_ms/1000,
      data = spotify_data,
      color = as.factor(year))

qplot(explicit,
      data = spotify_data,
      color = as.factor(explicit),
      geom = "bar")

qplot(as.factor(year), loudness,
      color = as.factor(year),
      data = spotify_data,
      geom = "boxplot")

qplot(popularity, danceability,
      data = spotify_data)

qplot(popularity, danceability,
      data = spotify_data,
      geom = c("point", "smooth"),
      method = "lm")

qplot(speechiness, genre1,
      data = spotify_data,
      geom = "boxplot",
      color = as.factor(year))

# Statistische Analysen

chisq.test(spotify_data$mode, spotify_data$explicit)
table(spotify_data$mode, spotify_data$explicit)

cor.test(spotify_data$energy, spotify_data$liveness)

t.test(popularity ~ explicit, data = spotify_data)

# Hilfreiche Dateien sind die RStudio Cheatsheets
# Base: https://www.rstudio.com/wp-content/uploads/2016/05/base-r.pdf
# GGPlot2: https://www.rstudio.com/wp-content/uploads/2015/05/ggplot2-cheatsheet.pdf
# RStudio: https://www.rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf
