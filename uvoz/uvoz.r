# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Funkcija, ki uvozi podatke o zmagah ekip v sezonah od 1984/85 do 2017/18.
uvozi.obcine <- function() {
  link <- "http://mcubed.net/nba/nbaera.pl?year1=2000&year2=2018&sortby=rswin"
  stran <- html_session(link) %>% read_html()
  vrstice <- stran %>% html_nodes(xpath="//span[@class='hovl']") %>% html_text()
  csv <- gsub(" {2,}", ",", vrstice) %>% paste(collapse="") #zamenja, kjer sta vsaj 2 presledka z vejicami
  
  stolpci <- c("IZBRIŠI2","število sezon v ligi", "Ekipa", "Št. zmag v rednem delu", "Št. porazov v rednem delu", "Odstotek zmag v rednem delu","Koliko krat v Play-offu", "PO zmage", "Play-off porazi","PO uspešnost", "Zmage serij","Porazi serij","Uspešnost v serijah","Nastopi v finalu", "Zmage v finalu","IZBRIŠI")
  
  podatki <- read_csv(csv, locale=locale(encoding="cp1250"), col_names=stolpci)
  
  #pobriši prvi in zadnji stolpec, določi imena stolpcev, spremeni procente v številke
  
tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table(dec=",")
for (i in 1:ncol(tabela)) {
  if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
                    locale=locale(encoding="Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars="obcina", variable.name="velikost.druzine",
                        value.name="stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels=obcine)
  return(data)
}

print(podatki)


uvoz <- read_csv()


# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
