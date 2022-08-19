# Daten mittels der Spotify Entwickler API (application programming interface),
# also der Anwendungsschnittstelle beziehen.

### Packages ###

# Hierzu benötigen wir einige packages, Software-Erweiterungen für R.

library(tidyverse) # zur Datenaufbereitung
if (!require(spotifyr)){
  install.packages("spotifyr", devtools::install_github("charlie86/spotifyr"))
} #
library(spotifyr) # Zur Kommunikation mit der API von Spotify
library(rvest) # Scraping - Programm zum "Ernten" von Informationen auf Webseiten
library(stringr) # Bearbeitung von Text (strings) in Datensätzen

### Spotify Zugang ###

# Bitte gehe zur Spotify Developer-Seite und registriere dich.
# https://developer.spotify.com/
# Dann kannst du deine eigene ID für den Zugang zur API verwenden.

Sys.setenv(SPOTIFY_CLIENT_ID = "DEINE_ID")

# dein "Secret" brauchst du auch.

Sys.setenv(SPOTIFY_CLIENT_SECRET = "DEIN_SECRET")

# Dann generieren wir einen "Schlüssel", mit dem man sich bei der API anmelden kann.

access_token <- get_spotify_access_token(Sys.getenv("SPOTIFY_CLIENT_ID"),
                                  Sys.getenv("SPOTIFY_CLIENT_SECRET"))

### Daten beziehen für deutsche Charts ###

url <- "https://www.billboard.com/charts/year-end/"

streaming_period <- c(2010:2021)

url_end <- "/hot-100-songs"

gathering_urls <- function(x){paste0(url, x, url_end)}

all_urls  <- gathering_urls(streaming_period)

# Diese Funktion hat Kework Kalustian, MPI Frankfurt geschrieben.
# er hat sie ursprünglich spotifyR-scrapeR genannt, danke!

charts_scrapeR <- function(x) {page <- x

chart_position <- page %>%
  read_html() %>%
  html_elements(".a-font-primary-bold-l") %>%
  html_text(trim = TRUE)

# Song/Track-Titel ziehen

title <- page %>%
  read_html() %>%
  html_elements("li") %>%
  html_elements("h3") %>%
  html_text(trim = TRUE)

# Artist Namen finden

artist <- page %>%
  read_html() %>%
  html_elements(".a-font-primary-s") %>%
  html_text(trim = TRUE)

tab <- data.frame(chart_position[3:102], title[1:100], artist[2:101])

return(tab)
}

# Das ganze wird in einen Datensatz gegeben und um die jeweiligen
# Erscheinungsjahre ergänzt.

charts_data <- map_df(all_urls, charts_scrapeR)
colnames(charts_data) <- c("chart_position", "title", "artist")

charts_data$year <- 0
charts_data$year[1:100] <- 2010
charts_data$year[101:200] <- 2011
charts_data$year[201:300] <- 2012
charts_data$year[301:400] <- 2013
charts_data$year[401:500] <- 2014
charts_data$year[501:600] <- 2015
charts_data$year[601:700] <- 2016
charts_data$year[701:800] <- 2017
charts_data$year[801:900] <- 2018
charts_data$year[901:1000] <- 2019
charts_data$year[1001:1100] <- 2020
charts_data$year[1101:1200] <- 2021

# Alle unnötigen Symbole und Satzzeichen in den Titel und Artistnamen werden gelöscht.

charts_data$artist <- gsub("Featuring ", "", charts_data$artist)
charts_data$artist <- gsub("&*", "", charts_data$artist)
charts_data$artist <- gsub(",", "", charts_data$artist)
charts_data$artist <- gsub("/", "", charts_data$artist)
charts_data$artist <- gsub(" x ", " ", charts_data$artist)
charts_data$artist[359] <- gsub("Tiara Thomas Or", "", charts_data$artist[359])
charts_data$artist[430] <- "Lil Wayne"
charts_data$artist[860] <- "Selena Gomez"
charts_data$title[928] <- "Ransom"
charts_data$artist[951] <- "Gucci Mane"
charts_data$artist[958] <- "Ellie Goulding"
charts_data$artist[1050] <- "Black Eyed Peas"
charts_data$artist[1088] <- "Kane Brown"
charts_data$artist <- gsub("\n", " ", charts_data$artist)
charts_data$artist <- str_trim(charts_data$artist, side = "both")
charts_data$title <- str_trim(charts_data$title, side = "both")
charts_data$title <- gsub("\n", " ", charts_data$title)
charts_data$chart_position <- gsub("\n", " ", charts_data$chart_position)
charts_data$chart_position <- as.numeric(charts_data$chart_position)

# Jetzt können die Audio Features von Spotify geladen werden.
# Hier sind die Audio Features aufgelistet:
# https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features

track_audio_features <- function(artist, title, type = "track") {
  search_results <- search_spotify(paste(artist, title), type = type)

  track_audio_feats <- get_track_audio_features(search_results$id[[1]])

  return(track_audio_feats)
}

# Mit der soeben definierten Funktion können nun die Daten in einen Tibble
# (tidyverse Format für Datensätze) gespeichert werden.

charts_af <- NULL

for(i in 1:nrow(charts_data)){
  new_row <- tibble(track_audio_features(charts_data$artist[i], charts_data$title[i]))
  charts_af <- rbind(charts_af, new_row)
}

charts <- cbind(charts_data, charts_af)
charts <- charts[, -(18:20)]
charts <- charts[, -16]

# Als nächstes wollen wir noch die Popularity und die Information über explicit
# content mit get_track() herausfinden.
# Zudem ermitteln wir noch die Spotify des jeweils zuerst genannten Artists.
# Die ID können wir nutzen, um anschließend Genres der Artists zu ziehen.

track_info <- NULL

for(i in 1:nrow(charts)){
  track <- get_track(charts$id[i])
  explicit <- as.logical(unlist(track[6]))
  popularity <- as.numeric(unlist(track[13]))
  artist_id <- as.character(track[[2]][2])
  row <- cbind(explicit, popularity, artist_id)
  track_info <- rbind(track_info, row)
}

track_info <- as.data.frame(track_info)

# Auch hier müssen wir wieder unnötige Symbole von den IDs entfernen und
# falls es mehrere Artists gibt, den erstgenannten ermitteln.

track_info$artist_id <- gsub("c\\(", "", track_info$artist_id)
track_info$artist_id <- gsub(")", "", track_info$artist_id)
artist_seperate <- str_split_fixed(track_info$artist_id, ", ", 2)
track_info <- cbind(track_info, artist_seperate)
colnames(track_info)[colnames(track_info) == "1"] <- "id_first_artist"
track_info$id_first_artist <- gsub('"', "", track_info$id_first_artist)

# Nun nutzen wir die Artist ID, um das 1. Genre zu ermitteln, die laut Spotify
# am häufigsten mit dem Artist assoziiert werden.

artist_genres <- NULL

for(i in 1:nrow(track_info)){
  id_first_artist <- as.character(track_info$id_first_artist[i])
  artist_info <- get_artist(track_info$id_first_artist[i])
  genre <- as.character(unlist(artist_info[3]))
  artist_info <- cbind(id_first_artist, genre[1])
  artist_genres <- rbind(artist_genres, artist_info)
}

artist_genres <- as.data.frame(artist_genres)
colnames(artist_genres) <- c("id_first_artist", "top_genre")

# Zuletzt noch alles in einen Datensatz fassen.

charts <- cbind(charts, track_info[,1:2])
charts <- cbind(charts, artist_genres[,2])
colnames(charts)[colnames(charts) == "artist_genres[, 2]"] <- "top_genre"

# Bestimmte features sollten noch gerundet werden.

charts$tempo <- round(charts$tempo)
charts$acousticness <- round(charts$acousticness, 4)
charts$instrumentalness <- round(charts$instrumentalness, 4)

# Zum Schluss speichern wir alles in einer csv Datei.

write.csv(charts, "./data/charts.csv")
