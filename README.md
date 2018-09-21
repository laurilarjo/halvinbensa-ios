# Halvin Bensa - Löydä halvin bensis lähelläsi

*Kun olet autoilemassa ja bensa alkaa loppua, eikö olisi näppärää jos voisit kännykällä katsoa halvimman bensa-aseman joka lähistöltä löytyy, ilman että sinun tarvitsee mennä sille vanhalle tutulle ja kalliille ABC:lle?*

*Halvin Bensa näyttää bensa-asemien hintatiedot ja reitittää sinut lähistöllä olevalle halvimmalle bensa-asemalle*

## Ajallinen konteksti (kirjoitettu syyskuussa 2018)

Ohjelma on kehitetty 2010 iPhonelle, hieman sen jälkeen kun iPhonen ohjelmille pystyi tekemään Google Maps API:n avulla reitityshakuja. Tämän ios-clientin lisäksi palveluun kuului taustapalvelu, joka oli rakennettu Djangolla (Python) ja pyöri Google AppEnginessä, tällöin vielä preview-vaiheessa. AppEngine oli Herokun jälkeen toinen PaaS alusta, mutta 2010 Heroku tarjosi vain Ruby-tukea, kun taas AppEngine tarjosi vain Pythonia. Oman teknisen haasteensa Django+AppEngine -komboon toi Djangon rajoitettu tuki relaatiokannalle, kun AppEngine tarjosi vain BigTable NoSQL-kantaa. Tähän löytyi alkuvaiheessa oleva NoSQL-Django ORM, mutta ongelmia oli vielä paljon...
