import 'package:flutter/material.dart';
import 'screens/sifre_sifirlama_sayfasi.dart';
import 'screens/giris_sayfasi.dart';
import 'screens/kayit_sayfasi.dart';
import 'screens/sifre_yonetimi_sayfasi.dart';
import 'screens/kullanici_sifre_guncelleme_sayfasi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter motorunun başlatıldığından emin olun
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ParolaYoneticisiApp());
}

class ParolaYoneticisiApp extends StatelessWidget {
  const ParolaYoneticisiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parola Yöneticisi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnaSayfa(),
      routes: {
        '/anaSayfa' : (context) => AnaSayfa(),
        '/girisSayfasi': (context) => GirisSayfasi(),
        '/kayitSayfasi': (context) => KayitSayfasi(),
        '/sifreYonetimSayfasi': (context) => SifreYonetimSayfasi(),
        '/sifreSifirlamaSayfasi': (context) => SifreSifirlamaSayfasi(),
        '/kullaniciSifreGuncellemeSayfasi': (context) => KullaniciSifreGuncellemeSayfasi(),
      },
    );
  }
}

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Parola Yöneticisi'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Giriş Yap", icon: Icon(Icons.login)),
              Tab(text: "Kayıt Ol", icon: Icon(Icons.person_add)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GirisSayfasi(),
            KayitSayfasi(),
          ],
        ),
      ),
    );
  }
}
