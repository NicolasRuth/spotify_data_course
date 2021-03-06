# Für unseren persönlichen Empfehlungsalgorithmus schreiben wir ein paar Regeln

# Ich mag es, wenn Songs schnell sind

mein_tempo_minimum <- 120 # ab 120 bpm mag ich es

# Ich stehe auf energiegeladene Musik

mein_genre1 <- as.character("dance pop")
mein_genre2 <- as.character("contemporary country")
mein_genre3 <- as.character("modern alternative rock")

# Es muss tanzbar sein

mein_dance <- 0.65 # es sollte mindestens eine Tanzbarkeit von 65 haben!

# Laut muss es sein

mein_db <- -7

# Ich finde es besser, wenn der Text überwiegend positiv ist

mein_value <- 0.50

# Jetzt nehmen wir diese Werte und nutzen sie als Regeln in unserem Algorithmus.
# Idealerweise kommt am Ende ein Wert raus, der mir sagt wie sehr mir der Song
# gefallen wird - sagen wir ein Wert zwisch 0 und 1 wobei 1 = gefällt mir am besten.

nick_mag <- function(songtitel) {
  auswahl <- spotify_data[spotify_data$title == songtitel, ]
  punkte <-  0
  if(auswahl$tempo >= mein_tempo_minimum) {punkte <- punkte + 1}
  if(auswahl$genre1 == mein_genre1 |
     auswahl$genre1 == mein_genre2 |
     auswahl$genre1 == mein_genre3) {punkte <- punkte + 1}
  if(auswahl$danceability >= mein_dance) {punkte <- punkte + 1}
  if(auswahl$loudness >= mein_db) {punkte <- punkte + 1}
  if(auswahl$valence >= mein_value) {punkte <- punkte +1}
  ergebnis <- (punkte/5) * 100
  sprintf("Der Song '%s' entspricht zu %d Prozent deinem Geschmack.",
          songtitel, ergebnis)
  }

# Testen wir mit dem Algorithmus, ob ich "3" von Britney Spears mag
nick_mag("Pumped Up Kicks")

# Schauen wir uns die Werte an, passt das?
spotify_data[spotify_data$title == as.character("Pumped Up Kicks"), ]

# Und im Vergleich "Hard" von Rihanna.
nick_mag("Humble And Kind")

spotify_data[spotify_data$title == as.character("Humble And Kind"), ]
