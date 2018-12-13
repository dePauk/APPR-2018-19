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
  
  stolpci <- c("IZBRISI2","Sezon_v_ligi", "Ekipa", "Zmage_redni_del", "Porazi_redni_del", "Odstotek_zmag_redni_del","Stevilo_playoffov", "Playoff_zmage", "Playoff_porazi","Playoff_uspesnost", "Zmage_serij","Porazi_serij","Uspesnost_serije","Nastopi_finale", "Zmage_finale","IZBRISI")
  
  podatki <- read_csv(csv, locale=locale(encoding="UTF-8"), col_names=stolpci)
  
  
  izbrisi2 <- podatki$IZBRISI2
  izbrisi <- podatki$IZBRISI
  
  podatki$IZBRISI2 <- NULL
  podatki$IZBRISI <- NULL

  odstotki1 <- podatki$Odstotek_zmag_redni_del
  odstotki1 <- as.numeric(sub("%","",podatki$Odstotek_zmag_redni_del,fixed=TRUE))/100 
  
  odstotki2 <- podatki$Playoff_uspesnost
  odstotki2 <- as.numeric(sub("%","",podatki$Playoff_uspesnost,fixed=TRUE))/100
  
  odstotki3 <- podatki$Uspesnost_serije
  odstotki3 <- as.numeric(sub("%","",podatki$Uspesnost_serije,fixed=TRUE))/100
  
  podatki$Odstotek_zmag_redni_del <- odstotki1
  
  podatki$Playoff_uspesnost <- odstotki2
  
  podatki$Uspesnost_serije<- odstotki3
  
  
  
  
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
  
  stolpci_igralci <- c("Starost","Konferenca","Datum_nagrade","Leto_drafta", "Visina", "Ime","Pozicija", "Sezona", "Sezona_okrajsano", "Stevilo_sezon_v_ligi", "Igralceva_ekipa", "Teza", "Vrednost_naziva")

  
  igralci_tedna <- read_csv("podatki/NBA_player_of_the_week.csv", locale = locale(encoding="UTF-8"), col_names = stolpci_igralci, skip=1)
  

  igralci_tedna$Visina <-  igralci_tedna$Visina %>% strapplyc("([0-9]+)") %>% sapply(function(x) {
    x <- parse_number(x)
    if (length(x) == 1) {
      return(x)
    } else {
      return(sum(x * c(12, 1)) * 2.54)
    }
  })
  
  
  #igralci_tedna %>% View
}



igralci_tedna %>% View

uvoz <- read_csv()

uvozi.sezonsko_stat <- function(){

  stolpci_statistika <- c("IZBRISI3", "Leto", "Igralec", "Pozicija", "Starost", "Ekipa", "Stevilo_iger", "Stevilo_zacetih_iger", "Odigrane_minute", "Player_efficiency_rating", "True_shooting", "3pt_attempt_rate", "Ft_rate", "Off_rebound_percentage", "Def_rebound_percentage", "Assist_percentage", "Steal_percentage", "Block_percentage", "Turnover_percentage")
  
  
  statistika <- read_csv("podatki/Seasons_Stats.csv", locale = locale(encoding="UTF-8"), col_names = stolpci_statistika, skip = 1)
  
  
  izbrisi3 <- statistika$IZBRISI3
  statistika$IZBRISI3 <- NULL
  
}



uVozi.all_star <- function(){
  link <- "https://en.wikipedia.org/wiki/List_of_NBA_All-Stars"
  stran <- html_session(link) %>% read_html()
  all_star_igralci <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable jquery-tablesorter']") %>% .[[2]] %>% html_table()
}

# Zapis podatkov v tabelo All-star
all_star_igralci <- uvozi.all_star()

#Poimenovanje stolpcev

all_star_igralci %>% View






all_star_igralci %>% View










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

