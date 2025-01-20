import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KullaniciSifreGuncellemeSayfasi extends StatefulWidget {
  @override
  _KullaniciSifreGuncellemeSayfasiState createState() =>
      _KullaniciSifreGuncellemeSayfasiState();
}

class _KullaniciSifreGuncellemeSayfasiState
    extends State<KullaniciSifreGuncellemeSayfasi> {
  final TextEditingController yeniSifreDenetleyici = TextEditingController();
  final TextEditingController yeniSifreTekrarDenetleyici =
  TextEditingController();

  bool sifreGizli = true;

  @override
  void dispose() {
    yeniSifreDenetleyici.dispose();
    yeniSifreTekrarDenetleyici.dispose();
    super.dispose();
  }

  Future<void> sifreGuncelle(BuildContext context) async {
    final yeniSifre = yeniSifreDenetleyici.text.trim();
    final yeniSifreTekrar = yeniSifreTekrarDenetleyici.text.trim();

    if (yeniSifre.isEmpty || yeniSifreTekrar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifre alanları boş olamaz.")),
      );
      return;
    }

    if (yeniSifre != yeniSifreTekrar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifreler birbiriyle uyuşmuyor.")),
      );
      return;
    }

    if (yeniSifre.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifre en az 6 karakterden oluşmalıdır.")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(yeniSifre);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre başarıyla değiştirildi.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre değiştirme sırasında hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Güncelleme'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: yeniSifreDenetleyici,
              obscureText: sifreGizli,
              decoration: InputDecoration(
                labelText: "Yeni Şifre",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.indigo,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      sifreGizli = !sifreGizli;
                    });
                  },
                  icon: Icon(
                    sifreGizli ? Icons.visibility : Icons.visibility_off,
                    color: Colors.indigo,
                  ),
                ),
                labelStyle: const TextStyle(color: Colors.indigo),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: yeniSifreTekrarDenetleyici,
              obscureText: sifreGizli,
              decoration: InputDecoration(
                labelText: "Yeni Şifre (Tekrar)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.indigo,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      sifreGizli = !sifreGizli;
                    });
                  },
                  icon: Icon(
                    sifreGizli ? Icons.visibility : Icons.visibility_off,
                    color: Colors.indigo,
                  ),
                ),
                labelStyle: const TextStyle(color: Colors.indigo),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => sifreGuncelle(context),
              child: const Text(
                'Şifreyi Güncelle',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
