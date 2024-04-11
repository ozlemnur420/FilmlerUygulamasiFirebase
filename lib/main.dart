
import 'package:filmler_uygulamasi_firebase/FilmlerSayfa.dart';
import 'package:filmler_uygulamasi_firebase/Kategoriler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  var refKategoriler = FirebaseDatabase.instance.ref().child("kategoriler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategoriler",style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refKategoriler.onValue,
        builder: (context,event){
          if(event.hasData){
            var kategoriListesi = <Kategoriler>[];

            var gelenDegerler = event.data!.snapshot.value as dynamic;

            if(gelenDegerler != null){
              gelenDegerler.forEach((key,nesne){
                var gelenKategori = Kategoriler.fromJson(key, nesne);
                kategoriListesi.add(gelenKategori);
              });
            }

            return ListView.builder(
              itemCount: kategoriListesi.length,
              itemBuilder: (context,indeks){
                var kategori = kategoriListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilmlerSayfa(kategori: kategori,)));
                  },
                  child: Card(
                    child: SizedBox(height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(kategori.kategori_ad,style: TextStyle(color: Colors.indigoAccent),),
                        ],
                      ),
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
