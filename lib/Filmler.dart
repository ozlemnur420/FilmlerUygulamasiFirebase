
class Filmler {
  String film_id;
  String film_ad;
  int film_yil;
  String film_resim;
  String kategori_ad;
  String yonetmen_ad;

  Filmler(this.film_id, this.film_ad, this.film_yil, this.film_resim,
      this.kategori_ad, this.yonetmen_ad);

  factory Filmler.fromJson(String key,Map<dynamic,dynamic> json){
    return Filmler(key // film_id
        , json["film_ad"] as String
        , json["film_yil"] as int
        , json["film_resim"] as String
        , json["kategori_ad"] as String
        , json["yonetmen_ad"] as String);
  }
}