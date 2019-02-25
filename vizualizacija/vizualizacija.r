# 3. faza: Vizualizacija podatkov

# Uspešnost ekip v rednem delu VS Uspešnost ekip v Play-Offih
ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Playoff_uspesnost)) + geom_point()

  
# Uspešnost ekip v rednem delu VS Število osvojenih nazivov igralca tedna v tem obdobju  
  
podatki.join <- inner_join(x = podatki_ekipe_imensko, y= stevilo_nazivov, by = "Ekipa") # %>% select("Ekipa", "Stevilo", "Uspesnost_redni_del")
  
ggplot(data=podatki.join, aes(x=podatki.join$Uspesnost_redni_del, y=podatki.join$Stevilo)) + geom_point(size=2,color="dodgerblue3")  
  
  
# Število osvojenih nazivov igralca tedna glede na pozicijo

      #Prirejena tabela - izločeni poziciji G-F in F-C zaradi zelo majhnega števila igralcev:
igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]

ggplot(data=igralci_tedna_pozicijefilt, aes(x=igralci_tedna_pozicijefilt$Sezona_okrajsano)) + geom_histogram(binwidth=1) + facet_grid(~Pozicija) #rezervna verizja


# Povprečna višina igralcev glede na pozicijo igranja

igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]

ggplot(data=igralci_tedna_pozicijefilt, aes(x=igralci_tedna_pozicijefilt$Pozicija, y=igralci_tedna_pozicijefilt$Visina)) + geom_boxplot(alpha=I(0.8),fill="firebrick1",outlier.size = 0.3)

#_______________________________________________


#NAREDI BOLJŠI GRAF IZ TEGA MOGOČE
ggplot(data=statistika, aes(x=statistika$Player_efficiency_rating, y=statistika$Leto)) + geom_point()

#NAREDI BOLJŠI GRAF IZ TEGA MOGOČE
ggplot(data=statistika, aes(x=statistika$Starost, y=statistika$Odigrane_minute)) + geom_smooth(model=lm)

#NAREDI BOLJŠI GRAF IZ TEGA MOGOČE
ggplot(data=statistika, aes(x=statistika$True_shooting, y=statistika$Player_efficiency_rating))+ geom_point() #+ facet_grid(~Starost)





#44
ggplot(data=podatki.join, aes(x=podatki.join$Kratice, fill=podatki.join$Uspesnost_redni_del)) + geom_bar() + xlab("Ekipa") 

















