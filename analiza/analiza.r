# 4. faza: Analiza podatkov


#6 Napoved števila igralcev tedna za centre

tabela_centri_vmesno <- igralci_tedna %>% filter(Pozicija == "C")
stetje <- count(tabela_centri_vmesno, Sezona_okrajsano)
tabela_centri <- as.data.frame(stetje)
pril_lm <- lm(data=tabela_centri, n~Sezona_okrajsano)
nova_leta <- data.frame(Sezona_okrajsano=seq(2019,2022,1))
napoved <- mutate(nova_leta, n=predict(pril_lm, nova_leta))

graf_napoved <- ggplot(tabela_centri, aes(Sezona_okrajsano,n)) + geom_smooth(method="lm", fullrange=TRUE)+
  geom_point(data=napoved,aes(Sezona_okrajsano,n),color="red", size=2)+
  geom_point() + ggtitle("Napoved števila centrov kot igralcev tedna") + xlab("Sezona")+ylab("Število")