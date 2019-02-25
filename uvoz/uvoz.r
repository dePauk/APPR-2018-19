library(rvest)
library(gsubfn)
library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")




#-----------------------------------------------------------------------------------------------------------------------------------------
# Funkcija, ki uvozi podatke o zmagah ekip v sezonah od 1984/85 do 2017/18.

uvozi.rezultate <- function() {
  link <- "http://mcubed.net/nba/nbaera.pl?year1=2000&year2=2018&sortby=rswin"
  stran <- html_session(link) %>% read_html()
  vrstice <- stran %>% html_nodes(xpath="//span[@class='hovl']") %>% html_text()
  csv <- gsub(" {2,}", ",", vrstice) %>% paste(collapse="") #zamenja, kjer sta vsaj 2 presledka z vejicami (v CSV)
  stolpci <- c("IZBRISI2","Sezon_v_ligi", "Ekipa", "Zmage_redni_del", "Porazi_redni_del", "Uspesnost_redni_del","Stevilo_playoffov", "Playoff_zmage", "Playoff_porazi","Playoff_uspesnost", "Zmage_serij","Porazi_serij","Uspesnost_serij","Nastopi_finale", "Zmage_finale","IZBRISI")
  
  podatki_ekipe <- read_csv(csv, locale=locale(encoding="UTF-8"), col_names=stolpci)
  
  podatki_ekipe <- podatki_ekipe[,-c(1,2,16)]

  odstotki1 <- podatki_ekipe$Uspesnost_redni_del
  odstotki1 <- as.numeric(sub("%","",podatki_ekipe$Uspesnost_redni_del,fixed=TRUE))/100 
  
  odstotki2 <- podatki_ekipe$Playoff_uspesnost
  odstotki2 <- as.numeric(sub("%","",podatki_ekipe$Playoff_uspesnost,fixed=TRUE))/100
  
  odstotki3 <- podatki_ekipe$Uspesnost_serij
  odstotki3 <- as.numeric(sub("%","",podatki_ekipe$Uspesnost_serij,fixed=TRUE))/100
  
  podatki_ekipe$Uspesnost_redni_del <- odstotki1
  podatki_ekipe$Playoff_uspesnost <- odstotki2
  podatki_ekipe$Uspesnost_serij <- odstotki3
  
  podatki_ekipe_imensko <- podatki_ekipe[order(podatki_ekipe$Ekipa),]
  

  ekipe_okrajsano = c("ATL","BKN","BOS","CHA","CHI","CLE","DAL","DEN","DET",
                      "GSW","HOU","IND","LAC","LAL","MEM","MIA","MIL","MIN",
                      "NOP","NYK","OKC","ORL","PHI","PHX","POR","SAC","SAS",
                      "TOR","UTA","WAS")

  podatki_ekipe_imensko$Kratice <- ekipe_okrajsano
  podatki_ekipe_imensko[,c(1,14,2,3,4,5,6,7,8,9,10,11,12,13)]

  #View(podatki_ekipe_imensko)
  
  
  return(podatki_ekipe_imensko)

}
  
podatki_ekipe_imensko <- uvozi.rezultate()






#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Funkcija, ki uvozi vse igralce tedna v sezonah od 1984/85 do 2017/18.

uvozi.igralce_tedna <- function(){
  
  stolpci_igralci <- c("Starost","Konferenca","Datum_nagrade","Leto_drafta", "Visina", "Ime","Pozicija", "Sezona", "Sezona_okrajsano", "Stevilo_sezon_v_ligi", "Igralceva_ekipa", "Teza", "Vrednost_naziva")
  igralci_tedna <- read_csv("podatki/NBA_player_of_the_week.csv", locale = locale(encoding="UTF-8"), col_types = cols("Teza" = col_skip()), col_names = stolpci_igralci, skip=1)


  # Za prikaz sezone bo dovolj le en stolpec in sicer bom uporabil tistega s končno letnico.
  # Število sezon v ligi pomeni število končani sezon, torej "Rookie-ji" imajo pri tej spremenljivki vrednost 0.
  
  igralci_tedna <- igralci_tedna[,-c(3,8)]


#  igralci_tedna$Teza <- (igralci_tedna$Teza) * 0.453592
#  igralci_tedna$Teza <- signif(igralci_tedna$Teza, digits = 3)  
  
  igralci_tedna$Visina <- igralci_tedna$Visina %>% strapplyc("([0-9]+)") %>% sapply(function(x) {
    x <- parse_number(x)
    if (length(x) == 1) {
      return(x)
    } else {
      return(sum(x * c(12, 1)) * 2.54)
    }
  })
  
  igralci_tedna$Visina <- signif(igralci_tedna$Visina, digits = 3)
  
  return(igralci_tedna)
}

#igralci_tedna %>% View

igralci_tedna <- uvozi.igralce_tedna()






#--------------------------------------------------------------------------------------------------------------------------------
# Funckija, ki iz tabele igralci_tedna prešteje število dobljenih nazivov igralca tedne vsake ekipe.


# Število različnih vrednosti v vsakem stolpcu tabele posebej
rapply(igralci_tedna, function(x)length(unique(x)))

# Vrne vrednost 35, 35- 30 = 5; torej vsaj 5 sprememb imen klubov v teh letih (če so igralci vsake ekipe vsaj enkrat dobili naziv)
# Spremembe: New Jersey Nets -> Brooklyn Nets, Washington Bullets -> Washington Wizards, Seattle SuperSonics -> Oklahoma City Thunder, Charlotte Hornets -> Charlotte Bobcats -> Charlotte Hornets, New Orleans Hornets -> New Orleans Pelicans

# stevilo_nazivov_ekipa nam pove, koliko nazivov Player of the Week so si izborili igralci vsake ekipe v opazovanem obdobju.
stevilo_nazivov_ekipa <- table(igralci_tedna$Igralceva_ekipa)

#data.frame ekip in številom osvojenih nazivov Player of the Week

tabela_stevilo_nazivov <- as.data.frame(table(igralci_tedna$Igralceva_ekipa))
tabela_stevilo_nazivov <- tabela_stevilo_nazivov[order(tabela_stevilo_nazivov$Var1),]
#tabela_stevilo_nazivov %>% View

tabela_stevilo_nazivov2 <- tabela_stevilo_nazivov

tabela_stevilo_nazivov2[3,2] <- 36
tabela_stevilo_nazivov2[35,2] <- 31
tabela_stevilo_nazivov2[24,2] <- 61
tabela_stevilo_nazivov2[5,2] <- 26
tabela_stevilo_nazivov2[22,2] <- 17

tabela_stevilo_nazivov2 <- tabela_stevilo_nazivov2[-c(4,20,21,31,34),]

rownames(tabela_stevilo_nazivov2) <- 1:nrow(tabela_stevilo_nazivov2)
#tabela_stevilo_nazivov2 %>% View

tabela_stevilo_nazivov_imena <- tabela_stevilo_nazivov2
tabela_stevilo_nazivov_imena <- as.character(tabela_stevilo_nazivov2$Var1) %>%
  
{ sub("New York Knicks", "New York Knickerbockers", ., fixed=TRUE) } %>% 

{ sub("Philadelphia Sixers", "Philadelphia 76ers", ., fixed=TRUE) }

stevilo_nazivov <- tabela_stevilo_nazivov2 %>%
  transmute(Ekipa = tabela_stevilo_nazivov_imena, Stevilo = Freq)

#stevilo_nazivov %>% View


# ŠTEVILO NAZIVOV GLEDE NA VREDNOST 0.5 ALI 1 ??



#-------------------------------------------------------------------------------------------------------------------------------------------
# Funkcija, ki uvozi statistiko velikega števila igralcev v ligi v sezonah od 1984/85 do 2017/18.

uvozi.sezonsko_stat <- function(){

  stolpci_statistika <- c("IZBRISI3", "Leto", "Igralec", "Pozicija", "Starost", "Ekipa", "Stevilo_iger", "Stevilo_zacetih_iger", "Odigrane_minute", "Player_efficiency_rating", "True_shooting", "3pt_attempt_rate", "Ft_rate", "Odstotek_skoki_napad", "Odstotek_skoki_obramba", "Odstotek_asistenc", "Ukradene_zoge", "Blokirani_meti", "Odstotek_izgubljenih_zog")
  statistika <- read_csv("podatki/Seasons_Stats.csv", locale = locale(encoding="UTF-8"), col_names = stolpci_statistika, skip = 7216)
  statistika <- statistika[,-c(1,12)]
  
  return(statistika)
  #statistika %>% View
}


statistika <- uvozi.sezonsko_stat






#----------------------------------------------------------------------------------------------------------------------------------------
# Funkcija, ki uvozi podatke o All-star igralcih.


uvozi.all_star <- function(){
  
  stolpci_allstar <- c("Igralec","Stevilo_allstar_nastopov","Sezone_allstar")
  
  link <- "https://en.wikipedia.org/wiki/List_of_NBA_All-Stars"
  stran <- html_session(link) %>% read_html()
  tabela_allstar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>% .[[1]] %>% html_table() %>%
    mutate(Player=Player %>% strapplyc("^([[:alnum:] '.-]*)") %>% unlist())
  
  tabela_allstar <- tabela_allstar[,-5]
  tabela_allstar <- tabela_allstar[,-4]
  
  names(tabela_allstar) <- stolpci_allstar
  
  return(tabela_allstar)
  tabela_allstar %>% View
}


tabela_allstar <- uvozi.all_star





#--------------------------------------------------------------------------------------------------------------------------------------------
podatki.join <- inner_join(x = podatki_ekipe_imensko, y= stevilo_nazivov, by = "Ekipa") # %>% select("Ekipa", "Stevilo", "Uspesnost_redni_del")
#View(podatki.join)

igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]
