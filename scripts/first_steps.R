# In der einfachsten Form ist R ein Taschenrechner

1 + 2 * 3

2 * 5^2 - 10 * 5

4 * sin(pi/2)

0 / 0

# R nutzt Objekt-basiertes Programmieren

fuenf <- 5 # man kann verschiedenste Objekte mit dem "assign operator" anlegen

print(fuenf)

# Objekte kann man anschließend verwenden

fuenf * 4

# R nutzt sogenannte Vektoren. Vektoren sind eine Sammlung an Werten

mein_vektor <- c(5,10,15,20,25) # c steht für concatenate - verknüpfen

mein_vektor * fuenf

# Um richtig zu programmieren, benötigen wir Funktionen. R hat eine ganze Menge
# Funktionen! Und noch mehr durch zahlreiche Packages

# Berechnen wir einen Mittelwert

zähler <- 5 + 10 + 15 + 20 + 25
nenner <- 5
zähler/nenner

sum(mein_vektor)/length(mein_vektor)

mittelwert <- function(x) {
  ergebnis <- sum(x)/length(x)
  print(ergebnis)
}

mittelwert(mein_vektor)

# Funktionen erkennen wir immer an den beiden Klammern. Natürlich gibt es unsere
# Funktion bereits in R: mean()

mean(mein_vektor)

# Probiert andere Funktionen aus: table(), median(), sort(), max(), min(), sqrt(),

# Logical operators helfen uns Regeln zu formulieren

mein_vektor >= 15

mean(mein_vektor) == 15

sum(mein_vektor) != 75
