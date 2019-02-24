# 3. faza: Vizualizacija podatkov


# Uspešnost ekip v rednem delu VS Uspešnost ekip v Play-Offih
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Playoff_uspesnost)) + geom_point()

# Uspešnost ekip v rednem delu VS Nastopi ekip v finalu
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Nastopi_finale)) + geom_point()

# Število uvrstitev v Play-Offe VS Uspešnost ekip v Play-Offih
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Stevilo_playoffov, y=podatki_ekipe_imensko$Playoff_uspesnost)) + geom_point()

#Uspešnost ekip v rednem delu VS Število nazivov igralca tedna
#zdruzi_ekipe_nazivi <- inner_join(podatki_ekipe_imensko, tabela_stevilo_nazivov_imena, by = "Ekipa")

-------------------------------
  
# Uspešnost ekip v rednem delu VS Število osvojenih nazivov igralca tedna v tem obdobju  
#ggplot(data=podatki.join, aes(x=podatki.join$Uspesnost_redni_del, y=podatki.join$Stevilo)) + geom_point(size=2,color="dodgerblue3")  
  
  
# Število nazivov glede na pozicijo 

#ggplot(data=statistika, aes(x=statistika$Player_efficiency_rating, y=statistika$Leto)) + geom_point()


ggplot(data=statistika, aes(x=statistika$Starost, y=statistika$Odigrane_minute)) + geom_smooth(model=lm)




# Bolj napredni grafi:

### v grafu ena izloči redke pozicije 

## ena
ggplot(data=igralci_tedna, aes(x=igralci_tedna$Pozicija, y=igralci_tedna$Visina)) + geom_boxplot(alpha=I(0.8),fill="firebrick1",outlier.size = 0.3)



### DODAJ VIŠINO GLEDE NA NPR. ŠTEVILO POTW IGRALCEV ALI KAJ PODOBNEGA



ggplot(data=podatki.join, aes(x=podatki.join$Kratice, fill=podatki.join$Zmage_redni_del)) + geom_bar() + xlab("Ekipa") 
