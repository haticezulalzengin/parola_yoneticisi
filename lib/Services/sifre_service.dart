import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/Sifre.dart';

class SifreServis {
  final CollectionReference _sifreler =
      FirebaseFirestore.instance.collection("sifre");

  Future<void> sifreEkleme(Sifre sifre) async {
    await _sifreler.add(sifre.toFirestore());
  }

  Future<void> sifreGuncelleme(Sifre sifre) async {
    await _sifreler.doc(sifre.id).update(sifre.toFirestore());
  }

  Future<void> sifreSilme(Sifre sifre) async {
    await _sifreler.doc(sifre.id).delete();
  }

  Stream<List<Sifre>> kullaniciSifreleri(String uid) {
    return _sifreler.where("KullaniciId", isEqualTo: uid).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                Sifre.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }


}
