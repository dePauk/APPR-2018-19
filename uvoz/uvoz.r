library(rvest)
library(gsubfn)
library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")



# ___________________________________________________________________________________________________________________________________________________________

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
  
  ekipe_okrajsano = c("ATL","BOS","BKN","CHA","CHI","CLE","DAL","DEN","DET",
                      "GSW","HOU","IND","LAC","LAL","MEM","MIA","MIL","MIN",
                      "NOP","NYK","OKC","ORL","PHI","PHX","POR","SAC","SAS",
                      "TOR","UTA","WAS")

  podatki_ekipe_imensko$Kratice <- ekipe_okrajsano
  podatki_ekipe_imensko[,c(1,14,2,3,4,5,6,7,8,9,10,11,12,13)]
  
  return(podatki_ekipe_imensko)

}
  
podatki_ekipe_imensko <- uvozi.rezultate()


#___________________________________________________________________________________________________________________________________________________________

#Funkcija, ki uvozi vse igralce tedna v sezonah od 1984/85 do 2017/18.

uvozi.igralce_tedna <- function(){
  
  stolpci_igralci <- c("Starost","Konferenca","Datum_nagrade","Leto_drafta", "Visina", "Ime","Pozicija", "Sezona", "Sezona_okrajsano", "Stevilo_sezon_v_ligi", "Igralceva_ekipa", "Teza", "Vrednost_naziva")
  igralci_tedna <- read_csv("podatki/NBA_player_of_the_week.csv", locale = locale(encoding="UTF-8"), col_types = cols("Teza" = col_skip()), col_names = stolpci_igralci, skip=1)

# Za prikaz sezone bo dovolj le en stolpec in sicer bom uporabil tistega s končno letnico.
# Število sezon v ligi pomeni število končani sezon, torej "Rookie-ji" imajo pri tej spremenljivki vrednost 0.
  
  igralci_tedna <- igralci_tedna[,-c(3,8)]

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

igralci_tedna <- uvozi.igralce_tedna()

igralci_tedna_pozicijefilt <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C",]
igralci_tedna_pozicijefilt2 <- igralci_tedna[igralci_tedna$Pozicija != "G-F" & igralci_tedna$Pozicija != "F-C" & igralci_tedna$Pozicija != "F",]


harden_nazivi <- igralci_tedna %>% filter(Ime == "James Harden")
harden_nazivi <- harden_nazivi[,-c(2,3,4,6,9,10)]
harden_nazivi$Sezona_okrajsano <- gsub("[0-2]{2}","", harden_nazivi$Sezona_okrajsano)

curry_nazivi <- igralci_tedna %>% filter(Ime == "Stephen Curry")
curry_nazivi <- curry_nazivi[,-c(2,3,4,6,9,10)]
curry_nazivi$Sezona_okrajsano <- gsub("[0-2]{2}","", curry_nazivi$Sezona_okrajsano)





stevilo_nazivov_zvezne = c(0,0,45,0,44+27+71+23,41,0,0,31,57+17,32,0,0,44,
                           23,0,0,0,17,0,0,43,29,26,0,0,0,0,0,0,0,0,36+36,
                           26,0,59,61,33,37,0,0,0,9,30+56+61,47,0,0,0,0,26,0)

nazivi_zvezne <- statepop
nazivi_zvezne$Nazivi <- stevilo_nazivov_zvezne


#___________________________________________________________________________________________________________________________________________________________

# Funckija, ki iz tabele igralci_tedna prešteje število dobljenih nazivov igralca tedne vsake ekipe.


# Število različnih vrednosti v vsakem stolpcu tabele posebej
rapply(igralci_tedna, function(x)length(unique(x)))

# Vrne vrednost 35, 35- 30 = 5; torej vsaj 5 sprememb imen klubov v teh letih (če so igralci vsake ekipe vsaj enkrat dobili naziv)
# Spremembe: New Jersey Nets -> Brooklyn Nets, Washington Bullets -> Washington Wizards, Seattle SuperSonics -> Oklahoma City Thunder, Charlotte Hornets -> Charlotte Bobcats -> Charlotte Hornets, New Orleans Hornets -> New Orleans Pelicans

# stevilo_nazivov_ekipa nam pove, koliko nazivov Player of the Week so si izborili igralci vsake ekipe v opazovanem obdobju.
stevilo_nazivov_ekipa <- table(igralci_tedna$Igralceva_ekipa)

# data.frame ekip in številom osvojenih nazivov Player of the Week

tabela_stevilo_nazivov <- as.data.frame(table(igralci_tedna$Igralceva_ekipa))
tabela_stevilo_nazivov <- tabela_stevilo_nazivov[order(tabela_stevilo_nazivov$Var1),]

tabela_stevilo_nazivov2 <- tabela_stevilo_nazivov
tabela_stevilo_nazivov2[3,2] <- 36
tabela_stevilo_nazivov2[35,2] <- 31
tabela_stevilo_nazivov2[24,2] <- 61
tabela_stevilo_nazivov2[5,2] <- 26
tabela_stevilo_nazivov2[22,2] <- 17
tabela_stevilo_nazivov2 <- tabela_stevilo_nazivov2[-c(4,20,21,31,34),]

rownames(tabela_stevilo_nazivov2) <- 1:nrow(tabela_stevilo_nazivov2)

tabela_stevilo_nazivov_imena <- tabela_stevilo_nazivov2
tabela_stevilo_nazivov_imena <- as.character(tabela_stevilo_nazivov2$Var1) %>%
  
{ sub("New York Knicks", "New York Knickerbockers", ., fixed=TRUE) } %>% 
{ sub("Philadelphia Sixers", "Philadelphia 76ers", ., fixed=TRUE) }

stevilo_nazivov <- tabela_stevilo_nazivov2 %>%
  transmute(Ekipa = tabela_stevilo_nazivov_imena, Stevilo = Freq)



stevilo_po_letih_vligi <- table(igralci_tedna$Stevilo_sezon_v_ligi)
tabela_nazivi_po_letih <- as.data.frame(table(igralci_tedna$Stevilo_sezon_v_ligi))
tabela_nazivi_po_letih$Var1 <- as.numeric(tabela_nazivi_po_letih$Var1)




podatki.join <- inner_join(x = podatki_ekipe_imensko, y= stevilo_nazivov, by = "Ekipa")





#___________________________________________________________________________________________________________________________________________________________

# Funkciji, ki uvozita statistiko dveh igralcev v vseh dosedajšnjih sezonah.

uvozi.harden <- function(){
  link <- "https://en.wikipedia.org/wiki/James_Harden"
  stran <- html_session(link) %>% read_html()
  tabela_harden_uvoz <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>% .[[1]] %>% html_table()
  
  tabela_harden <- tabela_harden_uvoz[-c(10,11),]
  tabela_harden$Year <- gsub("[0-9]{4}–","", tabela_harden$Year)
  tabela_harden$MPG <- gsub("\\*","", tabela_harden$MPG)
  tabela_harden$PPG <- gsub("\\*","", tabela_harden$PPG)
  tabela_harden$APG <- gsub("\\*","", tabela_harden$APG)
  
  tabela_harden$`FT%` <- as.numeric(tabela_harden$`FT%`)*100
  tabela_harden$`FG%` <- as.numeric(tabela_harden$`FG%`)*100
  tabela_harden$`3P%` <- as.numeric(tabela_harden$`3P%`)*100
  tabela_harden$MPG <- as.numeric(tabela_harden$MPG)
  tabela_harden$APG <- as.numeric(tabela_harden$APG)
  tabela_harden$PPG <- as.numeric(tabela_harden$PPG)
  
  tabela_harden <- tabela_harden[,-c(2,12)]
  tabela_harden <- as.data.frame(tabela_harden)
  tabela_harden$P_WEEK <- c(0,0,0,3,2,3,1,4,5)
  tabela_harden$Name <- c("Harden","Harden","Harden","Harden","Harden","Harden","Harden","Harden","Harden")
  
  return(tabela_harden)
  
}

tabela_harden <- uvozi.harden()





uvozi.curry <- function(){
  link <- "https://en.wikipedia.org/wiki/Stephen_Curry"
  stran <- html_session(link) %>% read_html()
  tabela_curry_uvoz <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>% .[[1]] %>% html_table()
  
  tabela_curry <- tabela_curry_uvoz[-c(10,11),]
  tabela_curry$Year <- gsub ("[^–0-9]","", tabela_curry$Year)
  tabela_curry$Year <- gsub("[0-9]{4}–","", tabela_curry$Year)
  tabela_curry$MPG <- gsub("\\*","", tabela_curry$MPG)
  tabela_curry$PPG <- gsub("\\*","", tabela_curry$PPG)
  tabela_curry$APG <- gsub("\\*","", tabela_curry$APG)
  tabela_curry$`FT%`<- gsub("\\*","", tabela_curry$`FT%`)
  tabela_curry$SPG <- gsub("\\*","", tabela_curry$SPG)
  
  tabela_curry$`FT%` <- as.numeric(tabela_curry$`FT%`)*100
  tabela_curry$`FG%` <- as.numeric(tabela_curry$`FG%`)*100
  tabela_curry$`3P%` <- as.numeric(tabela_curry$`3P%`)*100
  tabela_curry$MPG <- as.numeric(tabela_curry$MPG)
  tabela_curry$APG <- as.numeric(tabela_curry$APG)
  tabela_curry$PPG <- as.numeric(tabela_curry$PPG)
  tabela_curry$Year <- as.numeric(tabela_curry$Year)
  
  tabela_curry <- tabela_curry[,-c(2,12)]
  tabela_curry <- as.data.frame(tabela_curry)
  tabela_curry$P_WEEK <- c(0,0,0,0,0,2,5,3,2)
  tabela_curry$Name <- c("Curry","Curry","Curry","Curry","Curry","Curry","Curry","Curry","Curry")
  
  return(tabela_curry)
  
 
}

tabela_curry <- uvozi.curry()


zdruzena <- merge(tabela_curry, tabela_harden, all=TRUE)
zdruzena$Year <- as.numeric(zdruzena$Year)



