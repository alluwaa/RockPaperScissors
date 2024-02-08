import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(KiviSaksetPaperiPeli());
}

//Pää äppi ja navigaatio
class KiviSaksetPaperiPeli extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Piilottaa debug bannerin
      initialRoute: '/',
      routes: {
        '/': (context) => KotiValikko(),
        '/peli': (context) => KiviSaksetPaperi(),
        '/peli-loppu': (context) => PeliLoppuValikko(),
      },
    );
  }
}

// Koti ruutu
class KotiValikko extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( //Scaffoldi eli pohja visuaaleille
      appBar: AppBar( //app baari otsikolle
        title: Text('Kivi, Sakset, Paperi'), // Otsikko
        centerTitle: true, // Otsikon keskitys
      ),
      body: Center( //Runko
        child: Column( //kolumni
          mainAxisAlignment: MainAxisAlignment.center, // Keskittää kontentin, asettelua
          children: [ //lapsi johon painikkeet
            ElevatedButton( //painike
              onPressed: () { //kun painaa painiketta menee peli tilaan
                Navigator.pushNamed(context, '/peli'); //navigoi peli ruutuun
              },
              child: Text('Aloita peli'), // Pelin aloitus painike
            ),
            SizedBox(height: 25), //Boxi painikkeelle
            ElevatedButton( //Painike
              onPressed: () { //kun painetaan
                Navigator.pop(context); 
              },
              child: Text('Lopeta peli'), // Lopettaa pelin painike
            ),
          ],
        ),
      ),
    );
  }
}

// Peli ruutu
class KiviSaksetPaperi extends StatefulWidget {
  @override
  _KiviSaksetPaperiState createState() => _KiviSaksetPaperiState();
}

class _KiviSaksetPaperiState extends State<KiviSaksetPaperi> {
  final List<String> valinnat = ['Kivi', 'Paperi', 'Sakset'];

  String pelaajaValinta = '';
  String tietokoneValinta = '';

  String tulos = '';

  int pelaajanPisteet = 0;
  int tietokoneenPisteet = 0;

  //Funktio pelin pelaamiselle ja pelin logiikka
  void pelaaPeli(String valinta) {
    setState(() {
      pelaajaValinta = valinta;
      tietokoneValinta = valinnat[Random().nextInt(valinnat.length)]; //satunnaisuus tietokneen valintaant

      if (pelaajaValinta == tietokoneValinta) {
        tulos = 'Tasapeli!';
      } else if ((pelaajaValinta == 'Kivi' && tietokoneValinta == 'Sakset') ||
            (pelaajaValinta == 'Paperi' && tietokoneValinta == 'Kivi') ||
          (pelaajaValinta == 'Sakset' && tietokoneValinta == 'Paperi')) {
        tulos = 'Sinä voitit!'; 
        pelaajanPisteet++;
      } else {
        tulos = 'Sinä hävisit!';
        tietokoneenPisteet++;
      }

      //jos tietokoneella tai pelaajalla 3 pistettä peli päättyy
      if (pelaajanPisteet == 3 || tietokoneenPisteet == 3) {
      Navigator.pushNamed(context, '/peli-loppu', arguments: {
        'pelaajanPisteet': pelaajanPisteet,
        'tietokoneenPisteet': tietokoneenPisteet,
  });
}

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Pohja visuaaleille
      appBar: AppBar( //AppBaari otsikolle
        title: Text('Kivi, Sakset, Paperi'), // Otsikko
        centerTitle: true, // Keskittää otsikon
      ),
      body: Column( //Body
        mainAxisAlignment: MainAxisAlignment.center, // Keskittää sisällön
        children: [
          Text(
           'Paras viidestä', 
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            'Tee valintasi:', 
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 25), //Boxi painikkeille
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Järjestää painikkeet niin että niiden ympärillä on tilaa
            children: [
              ElevatedButton(
                onPressed: () => pelaaPeli('Kivi'),
                child: Text('Kivi'), // Ajaa pelin kivi valinnalla
              ),
              ElevatedButton(
                onPressed: () => pelaaPeli('Paperi'),
                child: Text('Paperi'), // Ajaa pelin paperi valinnalla
              ),
              ElevatedButton(
                onPressed: () => pelaaPeli('Sakset'),
                child: Text('Sakset'), // Ajaa pelin sakset valinnalla
              ),
            ],
          ),
          SizedBox(height: 30), // Boxi tekstille
          Text(
            'Sinun valinta: $pelaajaValinta\nTietokoneen valinta: $tietokoneValinta\n$tulos',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center, //Keskittää tekstin
          ),
          SizedBox(height: 30), // Boxi tekstille
          Text(
            'Pisteet\nSinä: $pelaajanPisteet\nTietokone: $tietokoneenPisteet',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center, //Keskittää tekstin
          ),
        ],
      ),
    );
  }
}

// Pelinlopetus valikko
class PeliLoppuValikko extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, int>? scores = ModalRoute.of(context)?.settings.arguments as Map<String, int>?;

    // Variablet pelaajan pisteille
    int pelaajanPisteet = scores?['pelaajanPisteet'] ?? 0;
    int tietokoneenPisteet = scores?['tietokoneenPisteet'] ?? 0;

    // Tekstit pelin lopetukselle
    String voittoTeksti = pelaajanPisteet > tietokoneenPisteet ? 'Sinä voitit!' : 'Sinä hävisit!';

    // Värit riippuen tuloksesta
    Color voittoVari = pelaajanPisteet > tietokoneenPisteet ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pelin Loppu'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Peli päättyi!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Tulos:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              voittoTeksti,
              style: TextStyle(
                fontSize: 18,
                color: voittoVari,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Sinä: $pelaajanPisteet',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Tietokone: $tietokoneenPisteet',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/peli');
              },
              child: Text('Yritä uudelleen!'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child: Text('Aloitus valikkoon'),
            ),
          ],
        ),
      ),
    );
  }
}


