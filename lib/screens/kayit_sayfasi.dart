import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KayitSayfasi extends StatefulWidget {
  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final TextEditingController epostaDenetleyici = TextEditingController();
  final TextEditingController sifreDenetleyici = TextEditingController();
  final TextEditingController sifreDogrulamaDenetleyici =
  TextEditingController();
  bool sifreGizli = true;

  @override
  void dispose() {
    epostaDenetleyici.clear();
    sifreDenetleyici.clear();
    sifreDogrulamaDenetleyici.clear();
    super.dispose();
  }

  void kayitOl(BuildContext context) async {
    if (epostaDenetleyici.text.isEmpty ||
        sifreDenetleyici.text.isEmpty ||
        sifreDogrulamaDenetleyici.text.isEmpty) {
      _gosterHata(context, "Lütfen tüm alanları doldurun!");
      return;
    }
    if (sifreDenetleyici.text != sifreDogrulamaDenetleyici.text) {
      _gosterHata(context, "Şifreler uyuşmuyor!");
      return;
    }

    if (sifreDenetleyici.text.length < 6) {
      _gosterHata(context, "Şifre en az 6 karakter olmalıdır!");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: epostaDenetleyici.text.trim(),
        password: sifreDenetleyici.text.trim(),
      );
      Navigator.pushNamed(context, '/anaSayfa');

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Doğrulama E-postası Gönderildi'),
            content: const Text(
                'E-posta adresinizi doğrulamak için gelen kutunuzu kontrol edin.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }

      Navigator.pushNamed(context, '/girisSayfasi');
    } catch (e) {
      Navigator.pop(context);
      _gosterHata(context, "Kayıt işlemi sırasında bir hata oluştu.");
    }
  }

  void _gosterHata(BuildContext context, String mesaj) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(mesaj),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: epostaDenetleyici,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.indigo,
                  ),
                  labelStyle: const TextStyle(color: Colors.indigo),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sifreDenetleyici,
                obscureText: sifreGizli,
                decoration: InputDecoration(
                  labelText: 'Şifre',
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
                controller: sifreDogrulamaDenetleyici,
                obscureText: sifreGizli,
                decoration: InputDecoration(
                  labelText: 'Şifre Doğrulama',
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
                onPressed: () => kayitOl(context),
                child: const Text(
                  'Kayıt Ol',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
