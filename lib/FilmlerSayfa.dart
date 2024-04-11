
import 'package:filmler_uygulamasi_firebase/DetaySayfa.dart';
import 'package:filmler_uygulamasi_firebase/Filmler.dart';
import 'package:filmler_uygulamasi_firebase/Kategoriler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FilmlerSayfa extends StatefulWidget {
  Kategoriler kategori;

  FilmlerSayfa({required this.kategori});

  @override
  _FilmlerSayfaState createState() => _FilmlerSayfaState();
}

class _FilmlerSayfaState extends State<FilmlerSayfa> {

  var refFilmler = FirebaseDatabase.instance.ref().child("filmler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmler : ${widget.kategori.kategori_ad}",style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refFilmler.orderByChild("kategori_ad").equalTo(widget.kategori.kategori_ad).onValue,
        builder: (context,event){
          if(event.hasData){
            var filmlerListesi = <Filmler>[];

            var gelenDegerler = event.data!.snapshot.value as dynamic;

            if(gelenDegerler != null){
              gelenDegerler.forEach((key,nesne){
                var gelenFilm = Filmler.fromJson(key, nesne);
                filmlerListesi.add(gelenFilm);
              });
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
              ),
              itemCount: filmlerListesi.length,
              itemBuilder: (context,indeks){
                var film = filmlerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(film: film ,)));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network("http://kasimadalan.pe.hu/filmler/resimler/${film.film_resim}"),
                        ),
                        Text(film.film_ad,style: TextStyle(color:Colors.indigo,fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                );
              },
            );
          }else{
            return Center();
          }
        },
      ),

    );
  }
}
