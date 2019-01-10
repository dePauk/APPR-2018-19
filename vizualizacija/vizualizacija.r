# 3. faza: Vizualizacija podatkov

# # Uvozimo zemljevid.
# zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                              pot.zemljevida="OB", encoding="Windows-1250")
# levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#   { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
# zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
# zemljevid <- fortify(zemljevid)
# 
# # Izračunamo povprečno velikost družine
# povprecja <- druzine %>% group_by(obcina) %>%
#   summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))


## Uspešnost ekip v rednem delu VS Uvrstitve v Play-Offe
#ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Stevilo_playoffov)) + geom_point()

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
ggplot(data=podatki.join, aes(x=podatki.join$Uspesnost_redni_del, y=podatki.join$Stevilo)) + geom_point()  
  
  
# Števiilo nazivov glede na pozicijo
  


