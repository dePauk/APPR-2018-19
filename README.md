# Analiza podatkov s programom R, 2018/19

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/dePauk/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/dePauk/APPR-2018-19/master?urlpath=rstudio) RStudio

## Igralci tedna in uspešnost njihovih ekip v ligi NBA

V projektu bom analiziral igralce tedna ("Player of the Week") lige NBA v sezonah od 1984/85 do 2017/18. Kot prvo bom primerjal igralce, ki so ta naslov osvoji vsaj enkrat in sicer tako glede na njihovo statistiko (igrane minute, odstotek zadetih metov in podobno) kot tudi glede na njihove lastnosti (pozicija igranja, starost, višina, teža, število let v ligi, v katerem "picku" na draftu so bili izbrani itd.). Dodal bom še število iger v tako imenovanih all-star tekmah.

Poleg tega bom skušal ugotoviti korelacijo med uspešnostjo ekipe - številom oziroma odstotkom dobljenih tekem v radnem delu ter v "play-offih" v istem obdobju - glede na število nazivov igralca tedna, ki so si jih priborili njihovi igralci v izbranih letih.

Ker je od sezone 2001/02 nagrada Player of the Week podeljena po enemu igralcu iz vzhodne in enemu iz zahodne divizije, je vrednost naslova od te sezone naprej 0.5, pred tem pa 1.0. Takrat je namreč nagrado dobil le eden od igralcev iz celotne lige. Za sezone od 1984/85 do 2000/01 bom tako lahko analiziral še število nazivov igralca tedna glede na divizijo in ga primerjal s številom skupnih zmag lige ekip vzhodne in zahodne divizije.


Podatke sem (bom) pobiral iz sledečih spletnih naslovov:

* https://www.kaggle.com/jacobbaruch/nba-player-of-the-week (CSV)
* https://www.kaggle.com/drgilermo/nba-players-stats (CSV)
* http://mcubed.net/nba/nbaera.pl?year1=2000&year2=2018&sortby=rswin (HTML)
* https://stats.nba.com/
* https://en.wikipedia.org/wiki/List_of_NBA_All-Stars (HTML)

## Tabele

1. tabela (Ekipe v NBA):

Stolpci: ekipa, št. zmag v rednem delu, št. porazov v rednem delu, delež zmag v rednem delu, število uvrstitev v Play-off (PO), št. zmaganih tekem v PO, št. izgubljenih tekem v PO, delež zmag tekem v PO, zmage serij v PO, porazi serij v PO, uspešnost serij v PO, št. nastopov v finalu, št. zmag celotne lige

2. tabela (Igralci tedna):

Stolpci: starost igralca, konferenca, datum osvojenega naziva, leto drafta igralca, višina, ime igralca, pozicija igranja, sezona (letnica spomladanskega dela), število sezon v ligi (brez trenutne), igralčeva ekipa, teža igralca, vrednost naziva (0.5 ali 1)

  2a. tabela, dobljena iz tabele 2:
  
  Stolpci: ekipa, število osvojenih nazivov igralca tedna

3. tabela: 

Stolpci: leto, igralec, pozicija igranja, starost, ekipa, število odigranih iger v sezoni, število začetih iger, odigrane minute, "player efficiency rating", "true shooting percentage" - uspešnost vseh metov, "free throw rate" - delež točk iz prostih metov, odstotek skokov v napadu, odstotek skokov v obrambi, "assist percentage" - delež točk, ki jih je ta igralec asistiral v času njegovega igranja (brez njegovih točk), ukradene žoge, blokirani meti, odstotek izgubljenih žog (koliko izgubljenih na 100 posesti)

4. tabela (All-star igralci):

  Stolpci: igralec, število uvrstitev v all-star ekipo, sezone uvrstitev v all-star ekipo



## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
