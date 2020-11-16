# Für unseren persönlichen Empfehlungsalgorithmus schreiben wir ein paar Regeln

# Ich mag es, wenn Songs schnell sind

mein_bpm <- 120 # ab 120 bpm mag ich es

# Ich stehe auf poppige Musik, hier sind meine 3 Lieblingsgenre

mein_genre1 <- as.character("dance pop")
mein_genre2 <- as.character("pop")
mein_genre3 <- as.character("electropop")

# Es muss tanzbar sein

mein_dance <- 65 # es sollte mindestens eine Tanzbarkeit von 65 haben!

# Laut muss es sein

mein_db <- -6

# Ich finde es besser, wenn der Text überwiegend positiv ist

mein_value <- 50

# Jetzt nehmen wir diese Werte und nutzen sie als Regeln in unserem Algorithmus.
# Idealerweise kommt am Ende ein Wert raus, der mir sagt wie sehr mir der Song
# gefallen wird - sagen wir ein Wert zwisch 0 und 1 wobei 1 = gefällt mir am besten.

nick_mag <- function(songtitel) {
  auswahl <- spotify_data[spotify_data$title == as.character(songtitel), ]
  punkte <-  0
  if(auswahl$bpm >= mein_bpm) {punkte <- punkte + 1}
  if(auswahl$genre == mein_genre1 |
     auswahl$genre == mein_genre2 |
     auswahl$genre == mein_genre3) {punkte <- punkte + 1}
  if(auswahl$dnce >= mein_dance) {punkte <- punkte + 1}
  if(auswahl$dB >= mein_db) {punkte <- punkte + 1}
  if(auswahl$val >= mein_value) {punkte <- punkte +1}
  ergebnis <- punkte/5
  print(ergebnis)
  }

# Testen wir mit dem Algorithmus, ob ich "3" von Britney Spears mag
nick_mag("3")

# Schauen wir uns die Werte an, passt das?
spotify_data[spotify_data$title == as.character("3"), ]

# Und im Vergleich "Hard" von Rihanna.
nick_mag("Hard")

spotify_data[spotify_data$title == as.character("Hard"), ]
