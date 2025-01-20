class Sifre {
  final String id;
  final String kullaniciId;
  final String kullaniciAdi;
  final String isim;
  final String sifre;
  final String url;
  final String not;

  Sifre({
    required this.id,
    required this.kullaniciId,
    required this.kullaniciAdi,
    required this.isim,
    required this.sifre,
    required this.url,
    required this.not,
  });

  factory Sifre.fromFirestore(String id, Map<String, dynamic> data){
    return Sifre(id: id,
        kullaniciId: data["KullaniciId"] ?? "",
        kullaniciAdi: data["KullaniciAdi"] ?? "",
        isim: data["Isim"] ?? "",
        sifre: data["Sifre"] ?? "",
        url: data["Url"] ?? "",
        not: data["Not"] ?? "");
  }

  Map<String, dynamic> toFirestore(){
    return {
      "KullaniciId" : kullaniciId,
      "KullaniciAdi" : kullaniciAdi,
      "Isim" : isim,
      "Sifre" : sifre,
      "Url" : url,
      "Not" : not,
    };
  }

}
