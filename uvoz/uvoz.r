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
  
  podatki_ekipe <- read_csv(csv, locale=locale(encoding="UTF-8"), col_names=stolpci)
  
  
  izbrisi2 <- podatki_ekipe$IZBRISI2
  izbrisi <- podatki_ekipe$IZBRISI
  
  podatki_ekipe$IZBRISI2 <- NULL
  podatki_ekipe$IZBRISI <- NULL

  odstotki1 <- podatki_ekipe$Odstotek_zmag_redni_del
  odstotki1 <- as.numeric(sub("%","",podatki_ekipe$Odstotek_zmag_redni_del,fixed=TRUE))/100 
  
  odstotki2 <- podatki_ekipe$Playoff_uspesnost
  odstotki2 <- as.numeric(sub("%","",podatki_ekipe$Playoff_uspesnost,fixed=TRUE))/100
  
  odstotki3 <- podatki_ekipe$Uspesnost_serije
  odstotki3 <- as.numeric(sub("%","",podatki_ekipe$Uspesnost_serije,fixed=TRUE))/100
  
  podatki_ekipe$Odstotek_zmag_redni_del <- odstotki1
  
  podatki_ekipe$Playoff_uspesnost <- odstotki2
  
  podatki_ekipe$Uspesnost_serije<- odstotki3
  
  
  podatki_ekipe_imensko <- podatki_ekipe[order(podatki_ekipe$Ekipa),]
  
  #podatki_ekipe_imensko %>% View
  
  
  #podatki_ekipe %>% View
  
  #print(podatki_ekipe)
  
  
  

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


#igralci_tedna %>% View




# Število različnih vrednosti v vsakem stolpcu tabele posebej
rapply(igralci_tedna, function(x)length(unique(x)))

#Ker dobim za ime ekip 35 različnih možnosti, bo sedaj manj možnosti, da pozabim kakšen klub (upoštevati je namreč treba spremembe imen, ki jih je bilo kar nekaj tekom let)
# 35- 30 = 5; torej vsaj 5 sprememb imen klubov v teh letih

# New Jersey Nets -> Brooklyn Nets
# Washington Bullets -> Washington Wizards
# Seattle SuperSonics -> Oklahoma City Thunder
# Charlotte Hornets -> Charlotte Bobcats (-> Charlotte Hornets)
# New Orleans Hornets -> New Orleans Pelicans


# stevilo_nazivov_ekipa nam pove, koliko nazivov Player of the Week so si izborili igralci vsake ekipe v opazovanem obdobju.

stevilo_nazivov_ekipa <- table(igralci_tedna$Igralceva_ekipa)
stevilo_nazivov_ekipa

#data.frame ekip in številom osvojenih nazivov Player of the Week

tabela_stevilo_nazivov <- as.data.frame(table(igralci_tedna$Igralceva_ekipa))

tabela_stevilo_nazivov <- tabela_stevilo_nazivov[order(tabela_stevilo_nazivov$Var1),]

#tabela_stevilo_nazivov
#tabela_stevilo_nazivov %>% View

tabela_stevilo_nazivov2 <- tabela_stevilo_nazivov

tabela_stevilo_nazivov2[3,2] <- 36
tabela_stevilo_nazivov2[35,2] <- 31
tabela_stevilo_nazivov2[24,2] <- 61
tabela_stevilo_nazivov2[5,2] <- 26
tabela_stevilo_nazivov2[22,2] <- 17

#tabela_stevilo_nazivov2

tabela_stevilo_nazivov_urejeno <- tabela_stevilo_nazivov2[-c(4,20,21,31,34),]

#tabela_stevilo_nazivov_urejeno

rownames(tabela_stevilo_nazivov_urejeno) <- 1:nrow(tabela_stevilo_nazivov_urejeno)

tabela_stevilo_nazivov_urejeno
tabela_stevilo_nazivov_urejeno %>% View


tabela_stevilo_nazivov_urejeno_imena <- tabela_stevilo_nazivov_urejeno
#tabela_stevilo_nazivov_urejeno_imena[20,1] <-     NE VEM, KAKO PREIMENOVAT 

#replace(tabela_stevilo_nazivov_urejeno_imena$Var1, "New York Knicks", "New York Knickerbockers")



# Številke vrstic za ekipe so sedaj kompatibilne s prvo tabelo -> lahko bom dodal te številke kar v tisto tabelo.
# TREBA JE LE PREIMENOVATI NEKAJ IMEN EKIP, NPR. SIXERS -> 76ERS, KNICKS -> KNICKERBOCKERS



uvoz <- read_csv()



uvozi.sezonsko_stat <- function(){

  stolpci_statistika <- c("IZBRISI3", "Leto", "Igralec", "Pozicija", "Starost", "Ekipa", "Stevilo_iger", "Stevilo_zacetih_iger", "Odigrane_minute", "Player_efficiency_rating", "True_shooting", "3pt_attempt_rate", "Ft_rate", "Off_rebound_percentage", "Def_rebound_percentage", "Assist_percentage", "Steal_percentage", "Block_percentage", "Turnover_percentage")
  
  
  statistika <- read_csv("podatki/Seasons_Stats.csv", locale = locale(encoding="UTF-8"), col_names = stolpci_statistika, skip = 1)
  
  
  izbrisi3 <- statistika$IZBRISI3
  statistika$IZBRISI3 <- NULL
  
}


#----------------------------------------------------------------------------------------------------------------------------------------

uVozi.all_star <- function(){
  link <- "https://en.wikipedia.org/wiki/List_of_NBA_All-Stars"
  stran <- html_session(link) %>% read_html()
  tabela_allstar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>% .[[1]] %>% html_table() %>%
    mutate(Player=Player %>% strapplyc("^([[:alnum:] '.-]*)") %>% unlist())
  
}

# Zapis podatkov v tabelo All-star
all_star_igralci <- uvozi.all_star()

#Poimenovanje stolpcev

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

ggplot(data = igralci_tedna, aes(x=igralci_tedna$Teza, y=igralci_tedna$Visina)) + geom_point()
