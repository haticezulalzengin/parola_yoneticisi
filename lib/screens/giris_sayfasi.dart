import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final TextEditingController epostaDenetleyici = TextEditingController();
  final TextEditingController sifreDenetleyici = TextEditingController();

  bool sifreGizli = true;

  @override
  void dispose() {
    epostaDenetleyici.clear();
    sifreDenetleyici.clear();
    super.dispose();
  }

  void girisYap(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: epostaDenetleyici.text.trim(),
        password: sifreDenetleyici.text.trim(),
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: epostaDenetleyici.text.trim(),
          password: sifreDenetleyici.text);

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        Navigator.pop(context);
        await FirebaseAuth.instance.signOut();
        _gosterHataMesaji(context, 'Hata',
            'Lütfen e-posta adresinizi doğruladıktan sonra giriş yapmayı deneyin.');
        return;
      }

      Navigator.pop(context);
      Navigator.pushNamed(context, '/sifreYonetimSayfasi');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı!')),
      );
    } catch (e) {
      Navigator.pop(context);
      sifreDenetleyici.clear();
      _gosterHataMesaji(context, "Hata", "Giriş işlemi sırasında bir hata oluştu.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => girisYap(context),
                child: const Text(
                  'Giriş Yap',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sifreSifirlamaSayfasi');
                },
                child: const Text(
                  'Şifremi Unuttum!',
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _gosterHataMesaji(BuildContext context, String baslik, String mesaj) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        baslik,
        style: const TextStyle(color: Colors.indigo),
      ),
      content: Text(mesaj),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tamam', style: TextStyle(color: Colors.indigo)),
        ),
      ],
    ),
  );
}
