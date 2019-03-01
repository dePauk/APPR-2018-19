# 4. faza: Analiza podatkov


#6 Napoved števila igralcev tedna za centre

tabela_centri_vmesno <- igralci_tedna %>% filter(Pozicija == "C")
stetje <- count(tabela_centri_vmesno, Sezona_okrajsano)
tabela_centri <- as.data.frame(stetje)

pril_lm <- lm(data=tabela_centri, n ~ Sezona_okrajsano)
nova_leta <- data.frame(Sezona_okrajsano=seq(2019,2022,1))
napoved <- mutate(nova_leta, n=predict(pril_lm, nova_leta))

graf_napoved <- ggplot(tabela_centri, aes(Sezona_okrajsano,n)) + geom_smooth(method="lm", fullrange=TRUE)+
  geom_point(data=napoved,aes(Sezona_okrajsano,n),color="red", size=2)+
  geom_point() + ggtitle("Napoved števila centrov kot igralcev tedna") + xlab("Sezona")+ylab("Število")



#7 Primerjava dveh igralcev


tabela_harden2 <- tabela_harden[,-c(2,3,4,5,6,7,8,9,10,11,13)]
tabela_harden2$Year <- as.numeric(tabela_harden2$Year)
tabela_harden2 <- as.data.frame(tabela_harden2)

pril_lmh <- lm(data=tabela_harden2,P_WEEK ~ Year)
nova_letah <- data.frame(Year=19)
napovedh <- mutate(nova_letah, P_WEEK=predict(pril_lmh,nova_letah))


tabela_curry2 <- tabela_curry[,-c(2,3,4,5,6,7,8,9,10,11,13)]
tabela_curry2$Year <- as.numeric(tabela_curry2$Year)
tabela_curry2 <- as.data.frame(tabela_curry2)

pril_lmc <- lm(data=tabela_curry2,P_WEEK ~ Year)
nova_letac <- data.frame(Year=19)
napovedc <- mutate(nova_letac, P_WEEK=predict(pril_lmc,nova_letac))




pril_lmh2 <- loess(data=tabela_harden2,P_WEEK ~ Year,control=loess.control(surface="direct"))
nova_letah2 <- data.frame(Year=19)
napovedh2 <- mutate(nova_letah2, P_WEEK=predict(pril_lmh2,nova_letah2))

pril_lmc2 <- loess(data=tabela_curry2,P_WEEK ~ Year,control=loess.control(surface="direct"))
nova_letac2 <- data.frame(Year=19)
napovedc2 <- mutate(nova_letac2, P_WEEK=predict(pril_lmc2,nova_letac2))
napovedc2[1,2] <- 0   # Ker vrednost ne more biti manjša od 0



graf_harden_curry2 <- ggplot(data=zdruzena, aes(Year,P_WEEK)) + geom_point(data = zdruzena %>% filter (Name =="Harden"), color="red", size=2.8) + 
  geom_smooth(data = zdruzena %>% filter (Name =="Harden"), color="red", fill="indianred1", size=1, method="loess") +
  geom_point(data= zdruzena %>% filter (Name == "Curry"), color = "darkgoldenrod", size =2.8) + theme_bw()+
  geom_smooth(data= zdruzena %>% filter (Name == "Curry"), color = "darkgoldenrod", fill="goldenrod1", size=1, method="loess") + 
  geom_point(data=napovedh,aes(Year,P_WEEK), color="tomato",size=6,shape=16)+
  geom_point(data=napovedh,aes(Year,P_WEEK), color="black",size=5,shape=49)+
  geom_point(data=napovedc,aes(Year,P_WEEK), color="goldenrod1",size=6,shape=16)+
  geom_point(data=napovedc,aes(Year,P_WEEK), color="black",size=5,shape=49)+
  geom_point(data=napovedh2, aes(Year, P_WEEK), color="tomato",size=6,shape=16)+
  geom_point(data=napovedh2, aes(Year, P_WEEK), color="black",size=5,shape=50)+
  geom_point(data=napovedc2,aes(Year,P_WEEK), color="goldenrod1",size=6,shape=16)+
  geom_point(data=napovedc2,aes(Year,P_WEEK), color="black",size=5,shape=50)+
  xlab("Sezona") + ylab("Igralec tedna") +
  ggtitle("Primerjava in napoved števila osvojenih nazivov igralca tedna") + theme(legend.position = "right") +
  annotate("text", x=16.8, y=7, label= "James Harden", color="red", size=5) + 
  annotate("text",x=14,y=-2,label="Stephen Curry", color="darkgoldenrod", size=5)
