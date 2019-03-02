# Analiza podatkov s programom R, 2018/19

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/dePauk/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/dePauk/APPR-2018-19/master?urlpath=rstudio) RStudio


## Igralci tedna in uspešnost njihovih ekip v ligi NBA

V projektu bom analiziral igralce tedna ("Player of the Week") lige NBA v sezonah od 1984/85 do 2017/18 glede na njihovo pozicijo, višino, število sezon v ligi in podobne spremenljivke. Poskušal bom ugotoviti, kako močna je korelacija med številom osvojenih nazivov igralca tedna posamezne ekipe in številom oziroma odstotkom dobljenih tekem teh ekip v istem obdobju. Raziskal bom kako se je pomembnost določenih pozicij spreminjala tekom sezon, saj vemo da se je v zadnjih desetletjih (oziroma celo letih) način igranja v ligi NBA opazno spremenil ter napovedal pomembnost centrov v prihodnosti. Ogledal si bom tudi zvezne države, ki so prejele največ nazivov.

Podatke sem pobral s sledečih spletnih naslovov:

* https://www.kaggle.com/jacobbaruch/nba-player-of-the-week (CSV)
* http://mcubed.net/nba/nbaera.pl?year1=2000&year2=2018&sortby=rswin (HTML)
* https://en.wikipedia.org/wiki/James_Harden (HTML)
* https://en.wikipedia.org/wiki/Stephen_Curry (HTML)


## Tabele

1. tabela (Ekipe v NBA):

Stolpci: ekipa, št. zmag v rednem delu, št. porazov v rednem delu, delež zmag v rednem delu, število uvrstitev v končnico, št. zmaganih tekem v končnici, št. izgubljenih tekem v končnici, delež zmag tekem v končnici, zmage serij v končnici, porazi serij v končnici, uspešnost serij v končnici, št. nastopov v finalu (oz. zmag konference), št. osvojenih nazivov lige

2. tabela (Igralci tedna):

Stolpci: starost igralca, konferenca igralčeve ekipe, leto drafta igralca, višina, ime igralca, pozicija igranja, sezona - letnica zaključka sezone, število sezon v ligi (brez trenutne), igralčeva ekipa, vrednost naziva (0.5 ali 1)

3. tabela (Statistika igralca Jamesa Hardena) in 4. tabela (Statistika igralca Stephena Curryja): 

Stolpci: sezona - letnica zaključka sezone, št. odigranih tekem, št. začetih tekem, povprečno št. odigranih minut na tekmo, delež zadetih metov iz igre, delež zadetih metov za 3 točke, delež zadetih prostih metov, povprečno št. skokov na tekmo, povp. število asistenc na tekmo, povp. število ukradenih žog na tekmo, povp. število točk na tekmo, št. nazivov igralca tedna, ime igralca


Ostale tabele so bile pridobljene iz zgornjih.


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
* `usmap` - za prikaz zemljevida


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
