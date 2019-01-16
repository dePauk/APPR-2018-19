# 3. faza: Vizualizacija podatkov


# Uspešnost ekip v rednem delu VS Uspešnost ekip v Play-Offih
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Playoff_uspesnost)) + geom_point()

# Uspešnost ekip v rednem delu VS Nastopi ekip v finalu
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Nastopi_finale)) + geom_point()

## Uspešnost ekip v rednem delu VS Število zmag lige NBA
#ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Zmage_finale)) + geom_point()

# Število uvrstitev v Play-Offe VS Uspešnost ekip v Play-Offih
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Stevilo_playoffov, y=podatki_ekipe_imensko$Playoff_uspesnost)) + geom_point()

##Število uvrstitev v Play-Offe VS Nastopi ekip v finalu
#ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Stevilo_playoffov, y=podatki_ekipe_imensko$Nastopi_finale)) + geom_point()

#Uspešnost ekip v rednem delu VS Število nazivov igralca tedna
#zdruzi_ekipe_nazivi <- inner_join(podatki_ekipe_imensko, tabela_stevilo_nazivov_imena, by = "Ekipa")

# TEST ZA RIBBON -----------------
#ggplot(data=igralci_tedna, aes(x=igralci_tedna$Sezona_okrajsano, y=igralci_tedna$Starost)) + geom_ribbon(ymin=igralci_tedna$Starost -1, ymax=igralci_tedna$Starost +1)
-------------------------------
  
# Uspešnost ekip v rednem delu VS Število osvojenih nazivov igralca tedna v tem obdobju  
ggplot(data=podatki.join, aes(x=podatki.join$Uspesnost_redni_del, y=podatki.join$Stevilo)) + geom_point(size=2,color="dodgerblue3")  
  
  
# Števiilo nazivov glede na pozicijo
  


