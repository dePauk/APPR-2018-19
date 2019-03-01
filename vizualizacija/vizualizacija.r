# 3. faza: Vizualizacija podatkov


#1 Število nazivov igralca tedna po zveznih državah
stevilo_nazivov_zvezne = c(0,0,45,0,44+27+71+23,41,0,0,31,57+17,32,0,0,44,23,0,0,0,17,0,0,43,
                               29,26,0,0,0,0,0,0,0,0,36+36,26,0,59,61,33,37,0,0,0,9,30+56+61,47,0,0,0,0,26,0)
nazivi_zvezne <- statepop
#Dodal bom nov stolpec s številom nazivov
nazivi_zvezne$Nazivi <- stevilo_nazivov_zvezne

graf_zda <- plot_usmap(data = nazivi_zvezne, values = "Nazivi", lines = "black") + 
  scale_fill_continuous(name = "Število", label = scales::comma) +
  theme(legend.position = "right") + ggtitle("Število nazivov igralca tedna po zveznih državah v sezonah 1984/85 do 2017/18")



#2 Uspešnost ekip v rednem delu VS Uspešnost ekip v Play-Offih
graf_korelacija_uspesn <- ggplot(data=podatki_ekipe_imensko, aes(x=podatki_ekipe_imensko$Uspesnost_redni_del, y=podatki_ekipe_imensko$Playoff_uspesnost)) + 
  geom_jitter(size=(podatki_ekipe_imensko$Stevilo_playoffov)/1.8, shape=16, color="dodgerblue3") + geom_smooth(method = "lm", color="red",size=0.6) +
  ggtitle("Korelacija deleža zmag v rednem delu in izločilnih bojih (Play-Offih)") + xlab("Uspešnost v rednem delu") + ylab("Uspešnost v Play-offih") +
  annotate("text", x = 0.63, y = 0.22, label = "Velikost kroga pomeni relativno število uvrstitev v izločilne boje", size=3) + theme_bw()



#3 Število osvojenih nazivov igralca tedna glede na število sezon v ligi (0 = sezona drafta)
graf_sezone <- ggplot(data=tabela_nazivi_po_letih, aes(x=Var1,y=Freq)) + geom_point(size=3, shape=16, color="grey15") + 
  geom_hline(yintercept=mean(tabela_nazivi_po_letih$Freq), color="red", size=0.6) + geom_smooth(color="black", size=0.8) +
  ggtitle("Število nazivov glede na število sezon v ligi") + xlab("Število sezon v ligi") + ylab("Število nazivov")+ theme_bw()
  annotate("text", x = 14, y = 145, label = "Število sezon pomeni število že zaključenih sezon pred trenutno", size = 3)



#4 Višina nagrajenih igralcev glede na pozicijo
igralci_tedna_pozicijefilt2 <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C" & igralci_tedna$Pozicija != "F",]
    
graf_visina_pozicija <- ggplot(data=igralci_tedna_pozicijefilt2, aes(x=reorder(Pozicija,igralci_tedna_pozicijefilt2$Visina), y=Visina)) + 
  geom_boxplot(alpha=I(1),fill="indianred3",outlier.size = 0.3) + ggtitle("Višina nagrajenih košarkarjev glede na pozicijo igranja") + 
  xlab("Pozicija igranja") + ylab("Višina igralcev") + theme_bw()



#5 Število osvojenih nazivov igralca tedna glede na pozicijo
#Prirejena tabela - izločeni pozicij G-F in F-C zaradi zelo majhnega števila igralcev:
igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]

graf_pozicije_cas <- ggplot(data=igralci_tedna_pozicijefilt, aes(x=igralci_tedna_pozicijefilt$Sezona_okrajsano)) + 
  geom_histogram(binwidth=1, color="gray30", fill="gray30") + facet_grid(~Pozicija) + theme_bw() + 
  theme(axis.text.x = element_text(angle=90))  + ggtitle("Osvojeni nazivi igralca tedna glede na pozicijo igranja skozi čas") + 
  xlab("Leto") + ylab("Število")


#6 --> analiza/analiza.r

#7 --> analiza/analiza.r

# #7 Primerjava dveh igralcev
# graf_harden_curry <- ggplot(data=zdruzena, aes(Year,P_WEEK)) + geom_point(data = zdruzena %>% filter (Name =="Harden"), color="red", size=2.8) + 
#   geom_smooth(data = zdruzena %>% filter (Name =="Harden"), color="red", fill="indianred1", size=1) +
#   geom_point(data= zdruzena %>% filter (Name == "Curry"), color = "darkgoldenrod", size =2.8) + theme_bw()+
#   geom_smooth(data= zdruzena %>% filter (Name == "Curry"), color = "darkgoldenrod", fill="goldenrod1", size=1) + xlab("Sezona") + ylab("Igralec tedna") +
#   ggtitle("Primerjava števila osvojenih nazivov igralca tedna") + theme(legend.position = "right") +
#   annotate("text", x=16.8, y=7, label= "James Harden", color="red", size=5) + 
#   annotate("text",x=14,y=-2,label="Stephen Curry", color="darkgoldenrod", size=5)
  


#8 Število zmag in število nazivov igralca tedna
podatki.join <- inner_join(x = podatki_ekipe_imensko, y= stevilo_nazivov, by = "Ekipa") # %>% select("Ekipa", "Stevilo", "Uspesnost_redni_del")
join_za_graf <- podatki.join %>% arrange(desc(Zmage_redni_del+Playoff_zmage))
graf_zmage_nazivi <- ggplot(data=join_za_graf, aes(x=reorder(Kratice,desc(Zmage_redni_del+Playoff_zmage)), y=Stevilo, fill=Zmage_redni_del+Playoff_zmage)) + 
  theme(axis.text.x = element_text(angle=90)) + geom_col() + xlab("Ekipa") + ggtitle("Število zmag in število osvojenih nazivov igralca tedna po ekipah") + 
  xlab("Ekipa") + ylab("Igralec tedna") + labs(fill="Zmage") 

  





##napoved števila centrov v prihodnosti


# tabela_centri_vmesno <- igralci_tedna %>% filter(Pozicija == "C")
# stetje <- count(tabela_centri_vmesno, Sezona_okrajsano)
# tabela_centri <- as.data.frame(stetje)
# 
# pril_lm <- lm(data=tabela_centri, n~Sezona_okrajsano)
# nova_leta <- data.frame(Sezona_okrajsano=seq(2019,2022,1))
# 
# napoved <- mutate(nova_leta, n=predict(pril_lm, nova_leta))
# 
# graf_napoved <- ggplot(tabela_centri, aes(Sezona_okrajsano,n)) + geom_smooth(method="lm", fullrange=TRUE)+
#                          geom_point(data=napoved,aes(Sezona_okrajsano,n),color="red", size=2)+
#                          geom_point() + ggtitle("Napoved števila centrov kot igralcev tedna") + xlab("Sezona")+ylab("Število")





  
















