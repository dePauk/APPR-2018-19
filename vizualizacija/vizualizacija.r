# 3. faza: Vizualizacija podatkov

# Uspešnost ekip v rednem delu VS Uspešnost ekip v Play-Offih

ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Playoff_uspesnost)) + 
  geom_jitter(size=(podatki_ekipe_imensko$Stevilo_playoffov)/1, shape=16, color="dodgerblue3") + geom_smooth(model=lm) + # geom_abline(intercept=0)+
  ggtitle("Korelacija uspešnosti") + xlab("Uspešnost v rednem delu") + ylab("Uspešnost v Play-offih")

  
# Uspešnost ekip v rednem delu VS Število osvojenih nazivov igralca tedna v tem obdobju  
  
podatki.join <- inner_join(x = podatki_ekipe_imensko, y= stevilo_nazivov, by = "Ekipa") # %>% select("Ekipa", "Stevilo", "Uspesnost_redni_del")
  
ggplot(data=podatki.join, aes(x=podatki.join$Uspesnost_redni_del, y=podatki.join$Stevilo)) + geom_point(size=2,color="dodgerblue3")  
  
  
# Število osvojenih nazivov igralca tedna glede na pozicijo

      #Prirejena tabela - izločeni poziciji G-F in F-C zaradi zelo majhnega števila igralcev:
      igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]

ggplot(data=igralci_tedna_pozicijefilt, aes(x=igralci_tedna_pozicijefilt$Sezona_okrajsano)) + geom_histogram(binwidth=1) + facet_grid(~Pozicija)


# Povprečna višina igralcev glede na pozicijo igranja

igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]

ggplot(data=igralci_tedna_pozicijefilt, aes(x=igralci_tedna_pozicijefilt$Pozicija, y=igralci_tedna_pozicijefilt$Visina)) + geom_boxplot(alpha=I(0.8),fill="firebrick1",outlier.size = 0.3)


# Število zmag in število nazivov igralca tedna

      #Vrstni red prilagojen, da bo graf preglednejši
      join_za_graf <- podatki.join %>% arrange(desc(Zmage_redni_del+Playoff_zmage))

ggplot(data=join_za_graf, aes(x=reorder(Kratice,desc(Zmage_redni_del+Playoff_zmage)), y=Stevilo, fill=Zmage_redni_del+Playoff_zmage)) + geom_col() + xlab("Ekipa") 


# Število nazivov igralca tedna po zveznih državah

stevilo_nazivov_zvezne = c(0,0,45,0,44+27+71+23,41,0,0,31,57+17,32,0,0,44,23,0,0,0,17,0,0,43,29,26,0,0,0,0,0,0,0,0,36+36,26,0,59,61,33,37,0,0,0,9,30+56+61,47,0,0,0,0,26,0)

nazivi_zvezne <- statepop

    #Dodal bom nov stolpec s številom nazivov
    nazivi_zvezne$Nazivi <- stevilo_nazivov_zvezne

plot_usmap(data = nazivi_zvezne, values = "Nazivi", lines = "black") + 
  scale_fill_continuous(name = "Število nazivov v sezonah 1984/85 do 2017/18", label = scales::comma) + 
  theme(legend.position = "right")
    


#_______________________________________________


##kaj v zvezi s številom sezon v ligi- igr. tedna
##par ekip, koliko naslovov na sezono, nato napredna analiza

























