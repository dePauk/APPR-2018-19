# 2. faza: Uvoz podatkov

library(rvest)
library(gsubfn)
library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Funkcija, ki uvozi podatke o zmagah ekip v sezonah od 1984/85 do 2017/18.
uvozi.rezultate <- function() {
  link <- "http://mcubed.net/nba/nbaera.pl?year1=2000&year2=2018&sortby=rswin"
  stran <- html_session(link) %>% read_html()
  vrstice <- stran %>% html_nodes(xpath="//span[@class='hovl']") %>% html_text()
  csv <- gsub(" {2,}", ",", vrstice) %>% paste(collapse="") #zamenja, kjer sta vsaj 2 presledka z vejicami (v CSV)
  
  stolpci <- c("IZBRIŠI2","število sezon v ligi", "Ekipa", "Št. zmag v rednem delu", "Št. porazov v rednem delu", "Odstotek zmag v rednem delu","Koliko krat v Play-offu", "PO zmage", "Play-off porazi","PO uspešnost", "Zmage serij","Porazi serij","Uspešnost v serijah","Nastopi v finalu", "Zmage v finalu","IZBRIŠI")
  
  podatki <- read_csv(csv, locale=locale(encoding="UTF-8"), col_names=stolpci)
  
  
  izbrisi2 <- podatki$IZBRIŠI2
  izbrisi <- podatki$IZBRIŠI
  
  podatki$IZBRIŠI2 <- NULL
  podatki$IZBRIŠI <- NULL

  odstotki1 <- podatki$`Odstotek zmag v rednem delu`
  odstotki1 <- as.numeric(sub("%","",podatki$`Odstotek zmag v rednem delu`,fixed=TRUE))/100 
  
  odstotki2 <- podatki$`PO uspešnost`
  odstotki2 <- as.numeric(sub("%","",podatki$`PO uspešnost`,fixed=TRUE))/100
  
  odstotki3 <- podatki$`Uspešnost v serijah`
  odstotki3 <- as.numeric(sub("%","",podatki$`Uspešnost v serijah`,fixed=TRUE))/100
  
  podatki$`Odstotek zmag v rednem delu` <- odstotki1
  
  podatki$`PO uspešnost` <- odstotki2
  
  podatki$`Uspešnost v serijah`<- odstotki3
  
  
  
  
  #View(podatki)
  
  
  #podatki %>% View
  

# tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
#   .[[1]] %>% html_table(dec=",")
# for (i in 1:ncol(tabela)) {
#   if (is.character(tabela[[i]])) {
#       Encoding(tabela[[i]]) <- "UTF-8"
#     }
#   }
#   colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
#                         "ustanovitev", "pokrajina", "regija", "odcepitev")
#   tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
#   tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
#   tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
#   for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
#     tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
#   }
#   for (col in c("obcina", "pokrajina", "regija")) {
#     tabela[[col]] <- factor(tabela[[col]])
#   }
#   return(tabela)
  
}



#Funkcija, ki uvozi podatke iz datoteke druzine.csv

# uvozi.druzine <- function(obcine) {
#   data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
#                     locale=locale(encoding="Windows-1250"))
#   data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
#     strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
#   data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
#   data <- data %>% melt(id.vars="obcina", variable.name="velikost.druzine",
#                         value.name="stevilo.druzin")
#   data$velikost.druzine <- parse_number(data$velikost.druzine)
#   data$obcina <- factor(data$obcina, levels=obcine)
#   return(data)
# }

#print(podatki)

#podatki %>% View

uvozi.igralce_tedna <- function(){
  
  stolpci_igralci <- c("Starost igralca","V/Z konferenca","Datum nagrade","Leto drafta igralca", "Višina igralca", "Ime igralca","Pozicija igranja", "Sezona", "Sezona okrajšano", "Število sezon v ligi", "Igralčeva ekipa", "Teža igralca", "Vrednost naziva")

  
  igralci_tedna <- read_csv("podatki/NBA_player_of_the_week.csv", locale = locale(encoding="UTF-8"), col_names = stolpci_igralci, skip=1)
  
  ft_to_cm1<- as.numeric(sub("-","",igralci_tedna$`Višina igralca`, fixed=TRUE))  #NAS introduced by coercion             #kar je do "-" recimo pomnoži z 30.48, kar je za tem pa z 2.54

  
  
# PRETVORI FT V CM
  
  
  #igralci_tedna %>% View
}



igralci_tedna %>% View

uvoz <- read_csv()

uvozi.sezonsko_stat <- function(){

  stolpci_statistika <- c("IZBRISI3", "Leto", "Igralec", "Pozicija igranja", "Starost", "Ekipa", "Število iger", "Število začetih iger", "Odigrane minute", "Player efficiency rating", "True shooting %", "3- point attempt rate", "Free throw rate", "Offensive rebound percentage", "Defensive rebound percentage", "Assist percentage", "Steal percentage", "Block percentage", "Turnover percentage")
  
  
  statistika <- read_csv("podatki/Seasons_Stats.csv", locale = locale(encoding="UTF-8"), col_names = stolpci_statistika, skip = 1)
  
  
  izbrisi3 <- statistika$IZBRISI3
  statistika$IZBRISI3 <- NULL
  
  
}


# Zapišimo podatke v razpredelnico obcine
#podatkiekip <- uvozi.rezultate()

# Zapišimo podatke v razpredelnico druzine.
#druzine <- uvozi.druzine(levels(obcine$obcina))



statistika %>% View


# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.



require(ggplot2)
require(dplyr)

ggplot(data = igralci_tedna, aes(x=igralci_tedna$`Teža igralca`, y=igralci_tedna$`Višina igralca`)) + geom_point()

